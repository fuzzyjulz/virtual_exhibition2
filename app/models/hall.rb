class Hall < ActiveRecord::Base
  include PaperclipUploadedFile

  HALL_TYPE = { exhibition: 'Exhibition',
                main: 'Main', 
                conference: 'Conference', 
                knowledge_lib: 'Knowledge Library',
                booth_list: 'Booth Listing'}
  
  resourcify
  has_ancestry

  belongs_to :event
  belongs_to :template
  belongs_to :welcome_video_content, class_name: 'Content'

  has_many :booths
  has_many :tags, -> { distinct } , through: :contents

  has_one :template_type, through: :template
  has_one :template_sub_type, through: :template
    
  has_and_belongs_to_many :contents

  enum publish_status: PublishStatus::OPTIONS
  
  validates :name, :publish_status, presence: true
  validates :event, :template, associated: true, presence: true

  paperclip_file  event_logo: UploadedFileType.hall_event_logo,
                  thumbnail_image: UploadedFileType.thumbnail,
                  background_image: UploadedFileType.background_image

  def to_param
      "#{id} #{name}".parameterize
  end
  
  def self.get_hall_by_type(hallList, hallType, hallSubType = nil)
    hallList = hallList.joins(:template).where(templates: {template_type: hallType})
    if hallSubType.present?
      hallList = hallList.where(templates: {template_sub_type: hallSubType})
    end
    if true or @current_user.nil? or @current_user.is_visitor?
      hallList = hallList.where(publish_status: PublishStatus.published.idx)
    end
    hallList.order(:name)
  end

  def location_name
    "#{event.name if event}: #{name}"
  end
  
  def recently_updated_content
    contents.where("updated_at > current_date - interval '#{Content::NEW_CONTENT_DAYS}' day")
  end

  def featured_content
    contents.where(featured: true)
  end
  
  def tagged_content(tag_objs)
    contents.joins(:tags).where("contents_tags.tags" => tag_objs)
  end
  
  def published_booths
    booths.where(publish_status: PublishStatus.published.idx)
  end
  
  def exhibition_hall?
    template.is_template_type?(:exhibitionHall) and template.is_template_sub_type?(:exhibition_hall)
  end

  def exhibition_hall_list?
    template.is_template_type?(:exhibitionHall) and template.is_template_sub_type?(:exhibition_hallsList)
  end
  
  def main_hall?
    template.is_template_type?(:mainHall)
  end

  def knowledge_hall?
    template.is_template_type?(:knowledgeLibraryHall) and template.is_template_sub_type?(:knowledge_knowledgeLibrary)
  end

  def knowledge_hall_tag_hall?
    template.is_template_type?(:knowledgeLibraryHall) and template.is_template_sub_type?(:knowledge_tagList)
  end
  
  def booth_list_hall?
    template.is_template_type?(:exhibitionHall) and template.is_template_sub_type?(:exhibition_boothList)
  end
  
  def topics
    tags.where(tag_type: :topic)
  end
  
  def keynotes
    tags.where(tag_type: :keynote)
  end
end
