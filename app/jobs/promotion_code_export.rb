require 'concerns/import_job_helper'

class PromotionCodeExport
  include Resque::Plugins::Status
  include TempFileHelper
  
  OUTPUT_TYPE = :download_file

  def setup(optionHash)
    @promotion = Promotion.find(optionHash[:promotion_id]) if optionHash[:promotion_id].present?
    @booth = Booth.find(optionHash[:booth_id]) if optionHash[:booth_id].present? 
    @event = Event.find(optionHash[:event_id]) if optionHash[:event_id].present?
    @current_user = User.find(optionHash[:current_user_id]) if optionHash[:current_user_id].present?
  end
  
  def perform
    setup(rekey_hash_by_sym(options))
    file_path = get_new_temp_file("promotion_codes","csv")
    
    CSV.open(file_path, "wb") do |csv|
      get_rows(csv)
    end
    
    puts file_path
    write_file_to_user(@current_user, file_path)
  end
  
  def get_rows(csv)
    csv << output_row(:header)
    
    promotion_codes = PromotionCode.assigned_promotion_codes
    if @promotion
      promotion_codes = promotion_codes.where(promotion: @promotion)
      object_type = "promotion"
    elsif @booth
      promotion_codes = promotion_codes.joins(:promotion).where(promotions: {booth_id: @booth})
      object_type = "booth"
    elsif @event
      promotion_codes = promotion_codes.joins(:booth).where(booths: {event_id: @event})
      object_type = "event"
    end

    promotion_codes.each do |promotion_code|
      csv << output_row(promotion_code)
    end
    
    if promotion_codes.size == 0
      csv << ["No records found. The #{object_type} does not contain any assigned promotion codes."]
    end
  end
  
  def output_row(row)
    time_format = "%e/%b/%Y %T (UTC%z)"
    columns = []
    promotion = row.promotion unless row == :header
    booth = promotion.booth unless row == :header
    if @event
      if row == :header
        columns << "Booth Name"
      else
        columns << booth.name
      end
    end

    if @booth || @event
      if row == :header
        columns << "Promotion Name"
      else
        columns << promotion.name
      end
    end
    
    if row == :header
      columns << "Promotion Code" << "Assigned to Firstname" << "Assigned to Surname" << "Assigned to email"
      columns << "Added to Cart At" << "Redeemed at"
    else
      user = row.assigned_to_user
      if user.nil?
        columns << row.code       << "user removed"          << "user removed"        << "user removed"
      else
        columns << row.code       << user.first_name         << user.last_name        << user.email
      end
      columns << (row.reserved_at ? row.reserved_at.strftime(time_format) : "") << (row.assigned_at ? row.assigned_at.strftime(time_format) : "")
    end
    
    columns
  end
end