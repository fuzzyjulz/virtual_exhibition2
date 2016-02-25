class Template < ActiveRecord::Base
  include PaperclipUploadedFile
  
  TEMPLATE_TYPE = { booth: "Booth",
                    mainHall: "Main Hall", 
                    knowledgeLibraryHall: "Knowledge Library Hall", 
                    exhibitionHall: "Exhibition Hall"}
  TEMPLATE_SUB_TYPE = { boothHall: TemplateSubType.new("Booth - Hall Format", :booth),
                        booth_v2: TemplateSubType.new("Booth - Promotion format", :booth),
                        knowledge_knowledgeLibrary: TemplateSubType.new("Knowledge Center - Knowledge Library", :knowledgeLibraryHall),
                        knowledge_tagList: TemplateSubType.new("Knowledge Center - Tag List", :knowledgeLibraryHall),
                        exhibition_hall: TemplateSubType.new("Exhibition Hall - Booth List", :exhibitionHall),
                        exhibition_hallsList: TemplateSubType.new("Exhibition Hall - Halls List", :exhibitionHall),
                        exhibition_boothList: TemplateSubType.new("Exhibition Hall - All Booth List", :exhibitionHall),
                        main_hall: TemplateSubType.new("Main Hall - v1", :mainHall),
                        main_hall_v2: TemplateSubType.new("Main Hall - v2", :mainHall)
                      }
  TEMPLATE_SUB_TYPE_LABELS =  {}.tap do |subtypeLabelMap|
                                TEMPLATE_SUB_TYPE.each_pair do |code, subType|
                                  subtypeLabelMap[code] = subType.name
                                end
                              end
  
  resourcify
  
  paperclip_file uploaded_file: UploadedFileType.template,
                 thumbnail_image: UploadedFileType.template_thumbnail

  scope :booth, -> { where(template_type: :booth) }

  validates :name, presence: true, uniqueness: true
  validates :template_type, :template_sub_type, presence: true

  def is_template_type?(type)
    template_type.to_sym == type
  end
  
  def template_type_code
    template_type
  end
  
  def template_type_label
    TEMPLATE_TYPE[template_type.to_sym]
  end
  
  def is_template_sub_type?(type)
    template_sub_type.to_sym == type
  end
  
  def self.template_sub_types
    TEMPLATE_SUB_TYPE
  end

  def self.template_sub_type_labels
    TEMPLATE_SUB_TYPE_LABELS
  end
  
  def self.template_types
    TEMPLATE_TYPE
  end
  
  def template_sub_type_label
    TEMPLATE_SUB_TYPE_LABELS[template_sub_type.to_sym]
  end
end
