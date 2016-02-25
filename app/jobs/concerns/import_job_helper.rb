require 'concerns/temp_file_helper'

module ImportJobHelper
  include TempFileHelper

  def perform
    begin
      puts "Starting import..."
      optionHash = rekey_hash_by_sym(options)
      @use_redis = !optionHash[:test_only].present?
      puts "  options: #{"test mode" if !@use_redis}"
      
      user = User.find(optionHash[:current_user_id])
        
      setup(optionHash)
      @job = self if @use_redis
      perform_import
      
      write_file_to_user(user, write_output_to_file)
      puts "Import finished"
    rescue => e
      puts "Import Failed:"
      puts e.message  
      puts e.backtrace.inspect
      failed("Import Failed: #{e.message}")
    end  
  end
  
  def write_row_error(message, row = nil)
    @processOutput << "*Line #{@rowIndex}:* "+message
    @processOutput << "*Line #{@rowIndex} Row:* #{row}" if row
  end
    
  def write_message(message)
    @processOutput << "#{message}"
  end
  
  def write_issues(issues)
    hasError = false
    
    issues.each do |issue|
      @processOutput << "*Column #{issue.type} '#{issue.column_name}':* #{issue.message}"
      hasError = true if issue.type == :error
    end
    
    hasError
  end
  
  def write_summary()
    rowCount = @rowIndex - 1
    @processOutput.insert(0, "")
    @processOutput.insert(0, "*Summary:* "+
      "Records: #{rowCount}, Saved: #{@savedCount}, New: #{@newCount}, Updated: #{@savedCount-@newCount}"+
      ", #{rowCount-@savedCount > 0 ? "*" : ""}Failed: #{rowCount-@savedCount}")
  end  
  
  class ValidationIssue
    attr_reader :type, :message, :column_name
    TYPES = [:warning, :error]
    
    def initialize(type, message, column_name)
      @type = type
      @message = message
      @column_name = column_name
    end
  end

  def write_output_to_file
    filePath = get_new_temp_file("user-import","csv")
    File.open(filePath, "w") do |outputFile|
      @processOutput.each do |line|
        outputFile.write(line+"\n")
      end
    end
    
    return filePath
    
  end
end