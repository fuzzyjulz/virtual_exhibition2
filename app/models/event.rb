class Event < ActiveRecord::Base
  include PaperclipUploadedFile
  
  resourcify
  has_many :halls, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :contents, dependent: :destroy
  has_and_belongs_to_many :users
  has_and_belongs_to_many :auth_models, dependent: :destroy
  has_many :booths , through: :halls
  belongs_to :landing_hall, class_name: "Hall"

  enum privacy: Privacy::OPTIONS

  validates :name, :privacy, :auth_models, :start, :finish, presence: true
  
  paperclip_file event_logo: UploadedFileType.venue_logo,
                 main_sponsor_logo: UploadedFileType.venue_main_sponsor,
                 event_image: UploadedFileType.event_image,
                 event_favicon: UploadedFileType.event_favicon,
                 sitemap: UploadedFileType.sitemap
  

  def self.get_public_events
    events = Event.where(privacy: Event.privacies[:public_scope])
    events = events.select {|event| event.live? and event.event_url.present?}
  end
  
  def published_booths
    booths.where(publish_status: PublishStatus.published.idx)
  end

  def published_halls
    halls.where(publish_status: PublishStatus.published.idx)
  end
  
  def get_event_logo
    mainHall = main_halls
    mainHall = mainHall.size > 0 ? mainHall[0] : nil
    if mainHall.present? and mainHall.event_logo.present?
      mainHall.event_logo
    elsif event_logo.present?
      event_logo
    end 
  end
  
  def privacy_label
    return nil if privacy.nil?
    Privacy[privacy].label
  end

  def exhibition_halls
    Hall.get_hall_by_type(halls, :exhibitionHall, :exhibition_hall)
  end

  def knowledge_halls
    Hall.get_hall_by_type(halls, :knowledgeLibraryHall, :knowledge_knowledgeLibrary)
  end
  
  def knowledge_hall
    knowledge_hall_list = knowledge_halls
    (knowledge_hall_list.size > 0 ? knowledge_hall_list[0] : nil)
  end

  def knowledge_hall_tag_hall
    Hall.get_hall_by_type(halls, :knowledgeLibraryHall, :knowledge_tagList)
  end

  def main_halls
    Hall.get_hall_by_type(halls, :mainHall)
  end

  def booth_list_halls
    Hall.get_hall_by_type(halls, :exhibitionHall, :exhibition_boothList)
  end
  
  def live?
    start.present? and finish.present? and start <= Date.today and finish >= Date.today
  end
  
  def domain
    return nil if !event_url.present?
    URI.parse(event_url).host
  end
end
