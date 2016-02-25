module UiHelper
  include ActionView::Helpers::AssetTagHelper

  def tooltip(title, placement = :bottom, html_options={})
    case placement
    when :top,:bottom,:left,:right
    else
      placement = :bottom
    end
    {"data-placement" => placement.to_s, "data-toggle" => "tooltip", "title" => title}.merge(html_options)
  end

  def box(columns = 6, title = nil, links = nil, colour = 'dark', class_name = '', footer = nil)
    haml_tag :div, :class => "col-lg-#{columns} #{class_name}", :id => title.downcase.gsub(" ", "") do
      haml_tag :div, :class => "box #{colour}" do
        haml_tag :header do
          haml_tag :div, :class => 'icons' do
            haml_tag :i, :class => 'fa fa-edit'
          end
          haml_tag :h5, :class => "tk-ff-meta-web-pro" do
            haml_concat title
          end
          if !links.nil?
            haml_tag :div, :class => 'toolbar' do
              haml_tag :ul, :class => 'nav' do
                links.each do |name, link|
                  haml_tag :li do
                    haml_concat "<a href='#{link}'>#{name}</a>"
                  end
                end
              end
            end
          end
        end
        haml_tag :div, :class => 'body' do
          yield
        end
        haml_tag :div, :class => 'footer' do
          haml_concat footer
        end
      end
    end
  end

  alias_method :baseImageTag, :image_tag
  def image_tag(image, options = nil)
    image = "missing.png" if (image == "/assets/original/missing.png")
    if (options)
      baseImageTag(image, options)
    else
      baseImageTag(image)
    end
  end
end