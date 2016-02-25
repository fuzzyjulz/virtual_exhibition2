class ContentType
  ENUM = [{id: :youtube_video, label: "Youtube Video", visitor_label: "Video"},
          {id: :vimeo_video, label: "Vimeo Video", visitor_label: "Video"},
          {id: :wistia_video, label: "Wistia Video", visitor_label: "Video"},
          {id: :slideshare, label: "Slideshare Presentation", visitor_label: "Presentation"},
          {id: :resource, label: "Resource", visitor_label: "Resource"},
          {id: :image, label: "Static Image", visitor_label: "Image"}]

  include EnumBase
  def self.visitor_labels
    {}.tap do |visitor_labels|
      self::ALL_ITEMS.each do |option|
        visitor_labels[option.id] = option.visitor_label
      end
    end
  end
end
