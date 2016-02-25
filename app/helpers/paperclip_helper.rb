module PaperclipHelper
  def build_resource (*resourceList)
    object = resource
    resourceList.each do |resource|
      if object.send(resource).nil?
        object.send("build_#{resource.to_s}")
      end
    end
  end

  def absolute_paperclip_image_tag(image, options = nil)
    if image.present? and @event.present?
      image_tag image.absolute_url(@event.event_url), options
    else
      paperclip_image_tag(image, options)
    end
  end
  
  def paperclip_image_tag(image, options = nil)
    if image.present? 
      image_tag image.assets.url, options
    else
      noImage = options[:noImage] if options
      noImage ||= "missing.png"
      image_tag asset_path(noImage), options
    end
  end
  
  def simple_form_image_paperclip(form_object, field_name, options = nil)
    label = options[:label] if options
    
    label = form_object.label(field_name) if label.nil?
    
    image = eval("form_object.object."+field_name.to_s)
    
    image_url = (image ? image.assets.url : asset_path("missing.png"))
    image_url = asset_path("missing.png") if (image_url == "/assets/original/missing.png")
  
    form_object.fields_for field_name do |field|
      haml_concat field.label :assets, label, :class => 'col-lg-4 control-label'
      haml_tag :div, :class => 'col-lg-8' do
        haml_tag :div, :class => 'fileinput '+((image.present? and (image.assets.present? or image.id.present?)) ? 'fileinput-exists' : 'fileinput-new'), "data-provides" => "fileinput" do
          haml_tag :div, :class => 'fileinput-preview thumbnail', "data-trigger" => "fileinput", "style" => "width:200px; height:150px;" do
            haml_tag :img, :src => image_url
          end
          haml_tag :div do
            haml_tag :span, :class => 'btn btn-default btn-file' do
              haml_tag :span, :class => 'fileinput-new' do
                haml_concat "Select image"
              end
              haml_tag :span, :class => 'fileinput-exists' do
                haml_concat "Change"
              end
              haml_concat field.file_field :assets
            end
            onclickmethod = "$('#"+field.lookup_model_names.join("_")+"_attributes_id').val('');"
            haml_tag :a, :class => 'btn btn-default fileinput-exists', :href => "#", "data-dismiss" => "fileinput", onclick: onclickmethod do
              haml_concat "Remove"
              
              #<input id="tag_thumbnail_image_attributes_id" name="tag[thumbnail_image_attributes][id]" type="hidden" value="344">
            end
          end
        end
      end
    end
  end

  def paperclip_environment?
    Rails.env.production? or Rails.env.staging? or Rails.env.vctest?
  end
end