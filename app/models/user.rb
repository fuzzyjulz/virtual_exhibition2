class User < ActiveRecord::Base
  include PaperclipUploadedFile
  
  LOCATIONS = {VIC: "Victoria", 
              NSW: "New South Wales", 
              ACT: "Australian Capital Territory", 
              QLD: "Queensland", 
              WA: "Western Australia", 
              SA: "South Australia", 
              TAS: "Tasmania", 
              NT: "Northern Territory",
              NZ: "New Zealand",
              INTL: "International"}
  
  # resourcify

  before_create :assign_default_role
  rolify :before_add => :before_add_method
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, 
         :lastseenable, :invitable
  devise :timeoutable, :timeout_in => 2.weeks

  has_and_belongs_to_many :events, :autosave => true

  has_many :booths
  has_many :from_user_chats, :foreign_key => 'from_user_id', :class_name => 'Chat'
  has_many :to_user_chats, :foreign_key => 'to_user_id', :class_name => 'Chat'
  has_many :assigned_promotion_codes, :foreign_key => 'assigned_to_user_id', :class_name => 'PromotionCode'
  
  attr_accessor :username
  
  paperclip_file uploaded_file: UploadedFileType.avatar,
                 csv_file: UploadedFileType.csv,
                 import_csv_file: UploadedFileType.import_csv

  validates :first_name, :last_name, presence: true
  validates :terms, :presence => true, :on => :create
  
  before_save do
    self.email = email.downcase if email
  end
 
  def name
    "#{first_name} #{last_name}"
  end
  
  def name_and_email
    "#{first_name} #{last_name} - #{email}"
  end
  
  def state_name
    LOCATIONS[state.to_sym] if state.present?
  end

  def avatar
    uploaded_file
  end
  
  def avatar_url
    if external_avatar_url.present?
      external_avatar_url
    else
      avatar.assets.url if avatar.present?
    end
  end
  
  def event_names
    events.pluck(:name)
  end
  
  def role_names
    roles.pluck(:name)
  end

  def booth_names
    booths.pluck(:name)
  end
  
  def live_events
    events.where("start <= ? AND finish >= ?", Date.today, Date.today)
  end

  def is_visitor?
    roles.empty? or (roles.size == 1 && has_role?(:visitor))
  end
  
  def before_add_method(role)
  	# do something
  end

  def assign_default_role
    add_role :visitor if !roles.present?
  end

  def self.admins
    User.joins(:roles).where(roles: {name: "admin"}).order(:first_name, :last_name)
  end
  
  def self.producers
    User.joins(:roles).where(roles: {name: "producer"}).order(:first_name, :last_name)
  end

  def self.reps
    User.joins(:roles).where(roles: {name: "booth_rep"}).order(:first_name, :last_name)
  end

  def self.event_admins
    self.admins + self.producers
  end
  
  def self.admins_and_reps
    self.admins + self.producers + self.reps
  end
  
  
  def self.from_omniauth(auth)
    provider = StringHelper.safe_chars(auth["provider"])
    uid = StringHelper.safe_chars(auth["uid"])
    nickname = StringHelper.safe_chars(auth.info.nickname)
    
    user = find_by(provider: provider, uid: uid)
    user = new() if user.nil?
    user.provider = provider
    user.uid = uid
    user.username = nickname if nickname.present?
    user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
