require 'concerns/import_job_helper'

class PromotionCodeImport
  include Resque::Plugins::Status
  include ImportJobHelper

  def setup(optionHash)
    @promotion = Promotion.find(optionHash[:promotion_id])
    @current_user = User.find(optionHash[:current_user_id]) if optionHash[:current_user_id].present?
    @importFile = @current_user.import_csv_file.content if @current_user.import_csv_file
  end
  
  def perform_import
    fileStr = @importFile
      
    @processOutput = []
    @savedCount = @newCount = @rowIndex = 0
    
    fileLines = fileStr.lines
    lineCount = fileLines.size
    
    fileLines.each_with_index do |row, rowIndex|
      @rowIndex = rowIndex+1
      process_row(row)
      
      @job.at(rowIndex, lineCount) if @job
    end

    write_summary
  end
  
  def process_row(row)
    row = row.strip
    return if !validate_row(row)
    
    code = row
    
    dbPromoCode = PromotionCode.find_by(promotion: @promotion, code: code)
    if dbPromoCode.present?
      write_row_error("Promotion code is already in the database", row)
      return
    else
      isNewRow = true
      dbPromoCode = PromotionCode.new(promotion: @promotion, code: code)
    end

    if dbPromoCode.save
      @savedCount += 1
      @newCount += 1 if isNewRow
    else
      write_row_error("Validations failed when saving user:#{user.errors.messages.to_json}", row)
      if isNewRow
        #we have a newly created user in the database that shouldn't be there!
        dbPromoCodeStored = PromotionCode.find_by(promotion: @promotion, code: code)
        dbPromoCodeStored.destroy
      end
    end
  end
  
  def validate_row(row)
    if (row =~ /^[\w\-]+$/).nil?
      write_row_error("Rows must contain only valid characters(a-z, A-Z, 0-9, _ or -)", row)
      false
    elsif row.size < 3
      write_row_error("Rows must contain atleast 3 characters", row)
      false
    elsif row.size > 30
      write_row_error("Rows must contain at most 30 characters", row)
      false
    else
      true
    end
  end
end