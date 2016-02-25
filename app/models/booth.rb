class Booth < ActiveRecord::Base
  include PaperclipUploadedFile
  resourcify

  belongs_to :user
  belongs_to :event
  belongs_to :template
  belongs_to :hall
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :products
  has_and_belongs_to_many :contents
  has_many :sponsored_videos, class_name: "Video", foreign_key: "sponsor_id"
  has_many :promotions

  enum publish_status: PublishStatus::OPTIONS
  enum promotion_type: PromotionType::OPTIONS
  
  paperclip_file company_logo: UploadedFileType.company, 
                 thumbnail_image: UploadedFileType.thumbnail,
                 about_us_header_image: UploadedFileType.about_us_header_image,
                 about_us_footer_image: UploadedFileType.about_us_footer_image

  has_many :chats, as: :chattable, dependent: :destroy
  accepts_nested_attributes_for :chats

  validates :name, :user, :event, :presence => { :message => "Cannot be blank" }
  validates :template, associated: true, presence: true
  validates :hall, associated: true, presence: true
  validates :publish_status, presence: true

  def to_param
      "#{id} #{name}".parameterize
  end
  
  def location_name
    "#{hall.event.name if hall and hall.event}: #{name}"
  end

  def followus(show = :used)
    followus = []
    followus << get_followus(:twitter, "twitter")
    followus << get_followus(:facebook, "facebook-square")
    followus << get_followus(:linkedin, "linkedin-square")
    followus << get_followus(:googleplus, "google-plus")
    followus = followus.select {|item| item.url.present?} if show == :used
    followus
  end
  
  def followus_item(name)
    followus.select {|item| item.name == name }.first
  end
  
  def get_followus(name, fontawesome_img)
    ActiveSupport::OrderedOptions.new().tap do |followus_item|
      followus_item.name = name
      followus_item.field = "followus_url_#{name}".to_sym
      followus_item.url = send(followus_item.field)
      followus_item.path = "booth_record_#{name}_path"
      followus_item.fontawesome_img = fontawesome_img
    end
  end
  
  def live_promotion
    promotions.select {|promo| promo.live?}.first
  end
end
