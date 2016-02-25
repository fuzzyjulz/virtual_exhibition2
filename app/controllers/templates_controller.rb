class TemplatesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]

  respond_to :html, :json
  responders :flash
  
  helper_method :get_template_types
  helper_method :get_template_sub_types

  # GET /templates
  def index
    @templates = Template.all
  end

  # GET /templates/1
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
    build_resources
  end

  # GET /templates/1/edit
  def edit
    build_resources
  end

  # POST /templates
  def create
    @template = Template.new(template_params)
    build_resources
    @template.save
    
    respond_with @template
  end

  # PATCH/PUT /templates/1
  def update
    @template.update(template_params)
    
    respond_with @template
  end

  # DELETE /templates/1
  def destroy
    @template.destroy
    respond_with @template
  end
  
  def template_sub_type
    if params[:template_type].present?
      subtypeLabelMap = {}
      Template.template_sub_types.each_pair do |code, subType|
        if subType.template_type.to_s == params[:template_type]
          subtypeObj = ActiveSupport::OrderedOptions.new
          subtypeObj.id = code
          subtypeObj.name = subType.name
          subtypeLabelMap[code] = subtypeObj
        end
      end
      respond_with subtypeLabelMap.to_json
    end
  end
    
  def get_template_sub_types(templateType = nil)
    if templateType.present?
      subtypeLabelMap = {}
      Template.template_sub_types.each_pair do |code, subType|
        subtypeLabelMap[code] = subType.name if subType.template_type == templateType.to_sym
      end
      return subtypeLabelMap.invert
    else
      return Template.template_sub_type_labels.invert
    end
  end
  
  def get_template_types()
    return Template.template_types.invert
  end

  private
    def build_resources
      build_resource :uploaded_file, :thumbnail_image
    end

    # Only allow a trusted parameter "white list" through.
    def template_params
      params.require(:template).permit(:name, :template_type, :template_sub_type, 
        { uploaded_file_attributes: [:assets, :id] }, { thumbnail_image_attributes: [:assets, :id] } )
    end
end
