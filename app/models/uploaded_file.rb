#A reuseable class for storing all types of files within the system
class UploadedFile < ActiveRecord::Base
  @@temp_content_type = nil

  belongs_to :imageable, polymorphic: true

  has_attached_file :assets,
    fog_file: lambda { |attachment|
        {
          content_type: attachment.assets_content_type
        }
      },
    s3_headers: lambda { |attachment|
      if attachment.assets_content_type.present?
        { 
          'Content-Type' => attachment.assets_content_type
        }
      elsif UploadedFile.temp_content_type.present?
        content_type = UploadedFile.temp_content_type
        UploadedFile.temp_content_type = nil
        { 
          'Content-Type' => content_type
        }
      else
        {}
      end
    }
  after_post_process :save_image_dimensions, if: Proc.new { |uploaded_file| uploaded_file.assets.content_type =~ /png|gif|jpeg/ }

  UploadedFileType::FileCategory.all.each do |category|
    fileTypes = UploadedFileType.all.select {|fileType| fileType.category == category}
    fileTypes = fileTypes.map {|fileType| fileType.id.to_s}
      
    validates_attachment_content_type :assets, 
        content_type: category.content_type,
        default_url: nil,
        message: "only #{category.id} are allowed and the size cannot exceed #{category.size_label()}",
        size: { :in => 0..category.max_file_size }, 
        if: Proc.new { |uploaded_file| fileTypes.include?(uploaded_file.image_type)}
  end

  def self.temp_content_type()
    @@temp_content_type
  end
  def self.temp_content_type=(content_type)
    @@temp_content_type = content_type
  end
  
  #Get the content of the file if it is in S3 or in a local file. 
  def content
    if assets.url.start_with?("/")
      IO.read(Rails.public_path.to_s+assets.url.sub(/\?.+/,""))
    else
      open(URI.parse(assets.url)).read
    end
  end
  
  def url
    assets.present? ? assets.url : nil
  end
  
  def absolute_url(hostname)
    if url.starts_with?("/")
      "#{hostname}#{url}"
    else
      url
    end
  end
  
  def present?
    super && assets.present?
  end
  
  def scaled_dimensions(width, height = width)
    image_dimensions = {}

    if image_width.nil? or image_height.nil?
      image_dimensions[:width] = width
      image_dimensions[:height] = height
      image_dimensions[:margin_top] = 0
      image_dimensions[:margin_left] = 0
    else
      orig_aspect = 1.0 * image_height / image_width
      
      if (orig_aspect * width) < image_height
        image_dimensions[:width] = width
        image_dimensions[:height] = (width * orig_aspect).round
        image_dimensions[:margin_top] = (height/2 - image_dimensions[:height]/2).round
        image_dimensions[:margin_left] = 0
      else
        image_dimensions[:width] = (height / orig_aspect).round
        image_dimensions[:height] = height
        image_dimensions[:margin_top] = 0
        image_dimensions[:margin_left] = (width/2 - image_dimensions[:width]/2).round
      end
    end
    image_dimensions
  end
end

def save_image_dimensions
  geo = Paperclip::Geometry.from_file(assets.queued_for_write[:original])
  self.image_width = geo.width
  self.image_height = geo.height
end

