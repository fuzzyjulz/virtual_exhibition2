class UpdateContentTypeToIds < ActiveRecord::Migration
  CT_ENUM = [{id: :youtube_video, label: "Youtube Video", visitor_label: "Video"},
          {id: :vimeo_video, label: "Vimeo Video", visitor_label: "Video"},
          {id: :wistia_video, label: "Wistia Video", visitor_label: "Video"},
          {id: :slideshare, label: "Slideshare Presentation", visitor_label: "Presentation"},
          {id: :resource, label: "Resource", visitor_label: "Resource"},
          {id: :image, label: "Static Image", visitor_label: "Image"}]
  def change
    CT_ENUM.each do |ct|
      execute("UPDATE contents SET content_type = '#{ct[:id]}' where content_type = '#{ct[:label]}'")
    end
  end
end
