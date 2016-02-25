class Tag < ActiveRecord::Base
  include PaperclipUploadedFile
  
  TAG_TYPE = {
              topic: "Topics",
              keynote: "Keynotes"
  }
  
  resourcify
	has_and_belongs_to_many :contents
  has_and_belongs_to_many :booths
  belongs_to :event

  paperclip_file thumbnail_image: UploadedFileType.thumbnail

  validates :name, :event, :tag_type, presence: true
  
  def tag_type_label
    TAG_TYPE[tag_type.to_sym]
  end
  def self.tag_type_labels
    TAG_TYPE.invert
  end
end
