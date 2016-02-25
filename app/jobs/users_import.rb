require 'concerns/import_job_helper'

class UsersImport
  include Resque::Plugins::Status
  include ImportJobHelper

  def setup(optionHash)
    @current_user = User.find(optionHash[:current_user_id]) if optionHash[:current_user_id].present?
    @importFile = @current_user.import_csv_file.content if @current_user.import_csv_file
  end
  
  def perform_import
    fileStr = @importFile
      
    @processOutput = []
    columnMapping = nil
    @savedCount = @newCount = @rowIndex = 0
    
    fileLines = fileStr.lines
    lineCount = fileLines.size
    
    fileLines.each do |row|
      if @rowIndex == 0
        #figure out column mapping array
        columnMapping = determine_columns(row)
        break if columnMapping.nil? # This will occur if we found a major problem with the columns
      else
        process_row(row, columnMapping)
      end
      
      @job.at(@rowIndex, lineCount) if @job
      @rowIndex += 1
    end

    write_summary
  end

  def determine_columns(row)
    columnMapping = []
    temp_user = User.new()
    issues = []

    row.split(/,/).each_with_index do |column_name, index|
      column_name = column_name.strip.downcase
      
      issue = validate_column_name(column_name, temp_user)
      if issue.nil?
        columnMapping[index] = column_name
      else
        issues << issue
      end
    end
    
    issue = validate_column_map(columnMapping)
    if issue.present?
      issues << issue
    end
    
    
    if write_issues(issues) == :error
      write_message("Processing halted. Resolve column name issues.")
      return nil
    end
    return columnMapping
  end

  def validate_column_name(column_name, temp_user)
    if column_name.blank?
      ValidationIssue.new(:warning, "blank column", column_name)
    elsif (column_name =~ /^[a-z]\w+$/).nil?
      ValidationIssue.new(:error, "not a valid column name", column_name)
    elsif !temp_user.respond_to? column_name
      ValidationIssue.new(:error, "not found on user", column_name)
    else
      nil
    end
  end
  
  def validate_column_map(columnMapping)
    if columnMapping.index("email").nil?
      ValidationIssue.new(:error, "'email' address is a required column.", "email")
    end
    if columnMapping.index("events").nil?
      ValidationIssue.new(:warning, "'events' column should be included.", "events")
    end
  end
  
  def validate_data_row(rowContentArr, columnMapping, row)
    #do some inital checks on the row to see if we can process it
    if rowContentArr.size != columnMapping.size
      write_row_error("Ignoring row, column count (#{rowContentArr.size}) does not match mapping (#{columnMapping.size})", row)
      return false
    end
    
    email = rowContentArr[columnMapping.index("email")].strip.downcase
    if email.blank?
      write_row_error("Ignoring row, email address cannot be empty")
      return false
    elsif (email =~ /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/).nil?
      write_row_error("Ignoring row, email address(#{email}) must be a valid email address", row)
      return false
    end
    
    return true
  end
  
  
  def process_row(row, columnMapping)
    isNewRow = false
    rowContentArr = row.split(/,/)
    
    return if !validate_data_row(rowContentArr, columnMapping, row)
    
    email = rowContentArr[columnMapping.index("email")].strip.downcase
    user = User.where(email: email).first
    
    if (user.nil?)
      user = create_new_user(email, columnMapping, rowContentArr, row)
      isNewRow = true
    end
    
    row.split(/,/).each_with_index do |column_value, index|
      column_name = columnMapping[index]

      set_value_on_user(user, column_name, column_value)
    end
    
    if user.save(:validate => true)
      @savedCount += 1
      @newCount += 1 if isNewRow
    else
      write_row_error("Validations failed when saving user:#{user.errors.messages.to_json}", row)
      if isNewRow
        #we have a newly created user in the database that shouldn't be there!
        userDB = User.find_by(email: user.email)
        userDB.destroy unless userDB.nil?
      end
    end 
  end
  
  def create_new_user(email, columnMapping, rowContentArr, row)
    password = rowContentArr[columnMapping.index("password")].strip
    if password.blank?
      write_row_error("Password must be set when creating a user", row)
      return
    end
    
    user = User.new({email: email, password: password, terms: true})
    user.roles = Role.where(name: "visitor").first unless columnMapping.index("roles")
    user.confirm! if defined? @user.confirm!
    
    user
  end
  
  def set_value_on_user(user, column_name, column_value)
    column_value = column_value.strip
    return if column_name.blank?
    if column_name == "email" && column_value
      column_value = column_value.downcase
    end
    
    if column_name == "roles"
      if column_value.blank?
        column_value = "visitor"
        write_row_error("No roles set, defaulting to visitor")
      end
      
      roles = column_value.split(",").map { |role| Role.where(name: role).first}
      write_row_error("Roles may not all exist: '#{column_value}'") if roles.include?(nil)
      roles.compact!
      column_value = "roles"
    elsif column_name == "events"
      events = column_value.split(",").map { |event| Event.where(name: event).first}
      write_row_error("Events may not all exist: '#{column_value}'") if events.include?(nil)
      events.compact!
      column_value = "events"
    elsif column_value.blank?
      column_value = "nil"
    elsif column_value =~ /^\d$/
      column_value = column_value
    else
      column_value = '"'+column_value+'"'
    end
    eval("user."+column_name+" = "+column_value)
  end
end