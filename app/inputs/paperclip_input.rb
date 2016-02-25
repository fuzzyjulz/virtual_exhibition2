
# Still a work in progress.
# use f.input :fieldname, as: Paperclip to use this code.
class PaperclipInput < SimpleForm::Inputs::Base
  def input()
    form_object = @builder
    
    image = eval("form_object.object."+attribute_name.to_s)
    
    image_url = (image ? image.assets.url : asset_path("missing.png"))
    image_url = asset_path("missing.png") if (image_url == "/assets/original/missing.png")
  
    form_object.fields_for attribute_name do |field|
      template.content_tag(:div, class: 'fileinput fileinput-new', "data-provides"=> "fileinput") do
        template.concat(template.content_tag(:div, class: 'fileinput-preview thumbnail', "data-trigger"=> "fileinput", "style"=> "width:200px; height:150px;") do
          template.content_tag(:img, "src"=> image_url)
        end.html_safe)
        template.content_tag(:div) do
          template.content_tag(:span, class: 'btn btn-default btn-file') do
            template.content_tag(:span, class: 'fileinput-new') do
              template.concat "Select image"
            end
            template.content_tag(:span, class: 'fileinput-exists') do
              template.concat "Change"
            end
            template.concat field.file_field :assets
          end
          template.content_tag(:a, class: 'btn btn-default fileinput-exists', href: "#", "data-dismiss"=> "fileinput") do
            template.concat "Remove"
          end
        end
      end
    end    
  end
end