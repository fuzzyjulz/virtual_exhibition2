#Provides a neat packaging up of a lot of the base abilities including the really ugly where clause
# and deletion of images id there is no id returned. Saves a lot of custom code.

module PaperclipUploadedFile
  extend ActiveSupport::Concern

  #Hijack the saving process and delete the image if it shouldn't be there. 
  def assign_attributes(parameters)
    write_temp_content_type(parameters)
    super
    delete_associated_image(parameters)
  end

  def update(parameters)
    assign_attributes(parameters)
    save
  end
  
  def update!(parameters)
    assign_attributes(parameters)
    save!
  end

  #Allows manually setting the content type in combination with the uploaded file class
  def write_temp_content_type(parameters)
    eachImageField(parameters) do |image|
      if image.present? and image[:assets].present? and image[:assets_content_type].present?
        UploadedFile.temp_content_type = image[:assets_content_type]
      end
    end
  end
  
  #remove the image if we don't have the image and we don't have an id recorded for the image
  def delete_associated_image(parameters)
    eachImageField(parameters) do |image, fieldName|
      if image.present? and image[:assets].blank? and image[:id].blank?
        image_var = send(fieldName)
        image_var.destroy if image_var
      end
    end
  end
  
  #Provides an each method for only image fields 
  def eachImageField(parameters)
    parameters.each_pair do |fieldName, value|
      if fieldName.to_s.end_with?("_attributes")
        yield value, fieldName.to_s.sub(/_attributes$/,"")
      end
    end
  end

  module ClassMethods
    #Add in the code to support a paperclip file 
    def paperclip_file(fields)
      fields.each_pair do |fieldName, uploadedFileType|
        has_one fieldName, ->{where(:image_type => uploadedFileType.db_id)}, as: :imageable, class_name: 'UploadedFile', dependent: :destroy
        accepts_nested_attributes_for fieldName, :reject_if => proc { |attributes| attributes['assets'].blank? }
      end
    end
  end
end
