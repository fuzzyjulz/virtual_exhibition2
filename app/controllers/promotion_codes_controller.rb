class PromotionCodesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  skip_load_resource :only => [:create]
    
  respond_to :html, :json
  responders :flash
  
  include FileImportProcess

  def index
    @promotion_codes = PromotionCode.where(promotion: @promotion)
  end
  
  def new
    @promotion_code.promotion = @promotion
  end

  def create
    @promotion_code = PromotionCode.new(new_clensed_params)
    @promotion_code.promotion = @promotion
    @promotion_code.save
    respond_with @promotion_code
  end

  def edit
  end

  def update
    resource.update(edit_clensed_params)
    respond_with resource
  end

  def destroy
    @promotion_code.delete
    respond_with(@promotion_code, location: promotion_promotion_codes_path(@promotion_code.promotion))
  end
  
  def destroy_all
    free_promo_codes = PromotionCode.free_promotion_codes.where(promotion: @promotion)
    free_promo_codes.each {|code| code.delete}
    flash[:success] = "Removed #{free_promo_codes.size} codes"
      
    redirect_to :back
  end
  
  def generate_codes
    params = generate_codes_params
    promo_code_template = params[:promo_code_template]
    id_start = params[:id_start]
    id_end = params[:id_end]
    
    begin
      codes_generated = generate_codes_job(promo_code_template, id_start.to_i, id_end.to_i)
      flash[:notice] = "#{codes_generated.size} codes generated."
    rescue Exception => e
      flash[:error] = "Couldn't generate codes: #{e}"
      logger.error e.to_s
      logger.error e.backtrace.join("\n")
    end
    
    redirect_to :back
  end
  
  def import_codes
    process_import(PromotionCodeImport, params[:importFile], promotion_id: @promotion.id)
  end
  
  def export_codes
    parameters = {}
    
    if @promotion.present?
      parameters[:promotion_id] = @promotion.id
    elsif @booth.present?
      parameters[:booth_id] = @booth.id
    elsif @event.present?
      parameters[:event_id] = @event.id
    end
    
    run_job(PromotionCodeExport, parameters)
    
    respond_to do |format|
      format.html {redirect_to system_job_status_path}
    end
  end
  
  def generate_codes_job(promo_code_template, id_start, id_end)
    generated_codes = []
    PromotionCode.transaction do
      (id_start..id_end).each do |id|
        promo_code = promo_code_template
        
        if ((matches = promo_code.match(/.*?(0+)/)) != nil)
          id_str = "%0#{matches[1].length}d" % id
          promo_code = promo_code.gsub(matches[1], id_str)
        end
        
        prng = Random.new
        if ((matches = promo_code.match(/.*?(#+)/)) != nil)
          id_str = "%0#{matches[1].length}d" % prng.rand(10 ** matches[1].length)
          promo_code = promo_code.gsub(matches[1], id_str)
        end
  
        if (PromotionCode.where(promotion: @promotion, code: promo_code).exists?)
          raise "The code '#{promo_code}' has already been taken."
        end
        
        promo = PromotionCode.new(promotion: @promotion)
        promo.code = promo_code
        promo.save!
        generated_codes << promo
      end
    end
    generated_codes
  end
  
  def generate_codes_params
    params.permit(:promotion_id, :promo_code_template, :id_start, :id_end)
  end
  
  def new_clensed_params
    params.require(:promotion_code).permit(:code, :promotion)
  end
  def edit_clensed_params
    params.require(:promotion_code).permit(:reserved_until)
  end
end