class MigrateTemplatesToTemplateSubTypes < ActiveRecord::Migration
  def change
    Template.all.each do |template|
      if template.template_sub_type.blank?
        case template.template_type
          when Template::TEMPLATE_TYPE[:booth]
            template.template_sub_type = Template::TEMPLATE_SUB_TYPE[:boothHall]
          when Template::TEMPLATE_TYPE[:webcast]
            template.template_sub_type = Template::TEMPLATE_SUB_TYPE[:webcast]
          when Template::TEMPLATE_TYPE[:mainHall]
            template.template_sub_type = Template::TEMPLATE_SUB_TYPE[:mainHall]
          when Template::TEMPLATE_TYPE[:conferenceHall]
            template.template_type = Template::TEMPLATE_TYPE[:knowledgeLibraryHall]
            template.template_sub_type = Template::TEMPLATE_SUB_TYPE[:knowledge_knowledgeLibrary]
          when Template::TEMPLATE_TYPE[:exhibitionHall]
            template.template_sub_type = Template::TEMPLATE_SUB_TYPE[:exhibition_hall]
        end
        template.save!
      elsif template.template_type == Template::TEMPLATE_TYPE[:conferenceHall] and 
          (template.template_sub_type == Template::TEMPLATE_SUB_TYPE[:knowledge_knowledgeLibrary] or template.template_sub_type == Template::TEMPLATE_SUB_TYPE[:knowledge_tagList]) 
        template.template_type = Template::TEMPLATE_TYPE[:knowledgeLibraryHall]
        template.save!
      end
    end
  end
end
