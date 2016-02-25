class UploadedFileType
  class FileCategory
    ENUM = [  {id: :image, max_file_size: 5000.kilobytes, content_type: /^image\/(png|gif|jpeg)/},
              {id: :favicon, max_file_size: 500.kilobytes, content_type: /^image\/(x-icon|png|gif)/},
              {id: :csv, max_file_size: 5000.kilobytes, content_type: /^(text\/csv|text\/comma-separated-values|application\/vnd.ms-excel)/},
              {id: :xml, max_file_size: 5000.kilobytes, content_type: /^application\/xml/},
              {id: :resource, max_file_size: 50000.kilobytes, content_type: /^application\/(vnd.ms-powerpoint|vnd.openxmlformats-officedocument.presentationml.presentation|vnd.openxmlformats-officedocument.wordprocessingml.document|pdf)/}]
    include EnumBase
    
    def size_label()
      if max_file_size / 1.megabytes > 0
        "#{max_file_size / 1.megabytes} megabytes"
      elsif max_file_size / 1.kilobytes > 0
        "#{max_file_size / 1.kilobytes} kilobytes"
      else
        "#{max_file_size} bytes"
      end
    end
  end
  
  ENUM = [  {id: :avatar, db_id: nil, category: FileCategory.image},
            {id: :product_image, db_id: nil, category: FileCategory.image},
            {id: :company, db_id: "company_logo", category: FileCategory.image},
            {id: :thumbnail, db_id: "thumbnail", category: FileCategory.image},
            {id: :venue_logo, db_id: "venue_logo", category: FileCategory.image},
            {id: :event_image, db_id: "event_image", category: FileCategory.image},
            {id: :background_image, db_id: "background_image", category: FileCategory.image},
            {id: :venue_main_sponsor, db_id: "venue_main_sponsor", category: FileCategory.image},
            {id: :template, db_id: "template", category: FileCategory.image},
            {id: :template_thumbnail, db_id: "template_thumbnail", category: FileCategory.image},
            {id: :hall_event_logo, db_id: "hall_event_logo", category: FileCategory.image},
            {id: :promotion_image, db_id: "promotion_image", category: FileCategory.image},
            {id: :about_us_header_image, db_id: "about_us_header_image", category: FileCategory.image},
            {id: :about_us_footer_image, db_id: "about_us_footer_image", category: FileCategory.image},

            {id: :resource_file, db_id: "resource_file", category: FileCategory.resource},
            {id: :csv, db_id: "csv", category: FileCategory.csv},
            {id: :import_csv, db_id: "import_csv", category: FileCategory.csv},
            {id: :event_favicon, db_id: "event_favicon", category: FileCategory.favicon},
            {id: :sitemap, db_id: "sitemap", category: FileCategory.xml}]
  include EnumBase

end