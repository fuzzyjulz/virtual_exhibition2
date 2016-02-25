class Product < ActiveRecord::Base
  include PaperclipUploadedFile

  resourcify

  has_and_belongs_to_many :booths

  paperclip_file uploaded_file: UploadedFileType.product_image

  validates :name, :description, presence: true
  validates :booths, presence: true
  
  def event
    booths.each {|booth| return booth.event}
  end
end
