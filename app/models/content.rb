class Content < ActiveRecord::Base
  CONTENT_TYPE = ContentType::LABELS.invert
  CONTENT_TYPE_CODE = ContentType::LABELS
  CONTENT_TYPE_LABEL = ContentType.visitor_labels

  VIDEO_CONTENT_TYPES = [:youtube_video, :vimeo_video, :wistia_video]
  NEW_CONTENT_DAYS = 7
  
  include PaperclipUploadedFile
                  
  resourcify
  
  belongs_to :event
  belongs_to :owner_user, class_name: "User"
  belongs_to :sponsor_booth, class_name: "Booth"
  has_and_belongs_to_many :booths
  has_and_belongs_to_many :halls
  has_and_belongs_to_many :tags
  enum privacy: Privacy::OPTIONS
  
  before_save :check_for_external_id_change
  
  paperclip_file resource_file: UploadedFileType.resource_file, 
                 thumbnail_image: UploadedFileType.thumbnail
  
  validates :name, :content_type, :event, :owner_user, :privacy, 
    presence: true

  def to_param
      "#{id} #{name}".parameterize
  end

  def privacy_label
    Privacy[privacy].label
  end

  def valid_content?(depth = :deep)
    case content_type_code
      when :youtube_video, :vimeo_video, :wistia_video
        external_id.present? && video_thumbnail_url.present? && (depth == :shallow || (video_info_service && video_info_service.available?))
      when :slideshare
        external_id.present?
      when :resource
        external_id.present? or resource_file.present?
      when :image
        thumbnail_image.present?
      else
        false
    end
  end
  
  def content_type_code
    content_type.to_sym
  end
  
  def content_type_obj
    ContentType[content_type]
  end
  
  def publically_visibile?
    public_scope? or welcome_video? or featured
  end

  def welcome_video?
    !Hall.where(welcome_video_content: self).empty?
  end
  
  def is_content_type?(type)
    content_type.to_sym == ContentType[type].id
  end
  
  def is_video?
    if content_type_code.present?
      VIDEO_CONTENT_TYPES.include?(content_type_code)
    else
      false
    end
  end
  
  def similar_sponsors
    {}.tap do |sponsorList|
      tags.each do |tag|
        sponsorList[tag] = tag.booths if tag.booths.present?
      end
    end
  end

  #Note: calling this creates the you tube session and is very costly.
  def video_info_service
    return nil unless external_id.present?
    
    VideoInfo::PROVIDERS << "Wistia" unless VideoInfo::PROVIDERS.include? "Wistia"
    case content_type_code
      when :youtube_video
        @video_info_obj ||= VideoInfo.new("http://www.youtube.com/watch?v=#{external_id}")
      when :vimeo_video
        @video_info_obj ||= VideoInfo.new("http://vimeo.com/#{external_id}")
      when :wistia_video
        @video_info_obj ||= VideoInfo.new("http://home.wistia.com/medias/#{external_id}")
      else
        nil
    end
  end
  
  def video_duration
    if duration.nil? and is_video? and valid_content?
      begin
        self.record_timestamps = false
        return nil if video_info_service.nil?
        self.duration = video_info_service.duration
        save(validate: false)
        self.record_timestamps = true
      rescue => e
        logger.error("Error(duration): #{e}")
      end
    end
    duration.present? ? Time.at(duration).utc.strftime("%H:%M:%S").sub(/^00:/,"").sub(/^0/,"") : nil
  end
  
  def video_thumbnail_url
    image_url = nil
    if !is_video?
      image_url = nil
    elsif thumbnail_image.present?
      image_url = thumbnail_image.url
    else
      if thumbnail_url.nil? 
        begin
          self.record_timestamps = false
          return nil if video_info_service.nil?
          case content_type_code
            when :youtube_video
              self.thumbnail_url = video_info_service.thumbnail_medium
            when :vimeo_video
              self.thumbnail_url = video_info_service.thumbnail_large
            when :wistia_video
              self.thumbnail_url = video_info_service.thumbnail_medium
          end
          save(validate: false)
          self.record_timestamps = true
          image_url = thumbnail_url
        rescue => e
          logger.error("Error(video_thumbnail_url): #{e}")
          nil;
        end
      end
      image_url = thumbnail_url
    end
    image_url
  end
  
  def clear_cached_video_info
    self.duration = nil
    self.thumbnail_url = nil
  end
  
  def check_for_external_id_change
    if id.present?
      original_content = Content.find(id)
      if original_content.external_id != external_id
        clear_cached_video_info
      end
    end
  end
  
  def flags
    if @flags.present?
      return @flags
    end if
    @flags = [].tap do |flags|
      flags << :featured if featured
      flags << :new if updated_at > Time.now - NEW_CONTENT_DAYS.days
      flags << :locked if !publically_visibile?
    end
    @flags = [] if @flags.nil?
    @flags
  end
end