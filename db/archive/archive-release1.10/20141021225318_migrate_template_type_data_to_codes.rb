class MigrateTemplateTypeDataToCodes < ActiveRecord::Migration
  def change
    execute "UPDATE templates SET template_type = 'booth' where template_type = 'Booth'"
    execute "UPDATE templates SET template_type = 'mainHall' where template_type = 'Main Hall'"
    execute "UPDATE templates SET template_type = 'knowledgeLibraryHall' where template_type = 'Knowledge Library Hall'"
    execute "UPDATE templates SET template_type = 'exhibitionHall' where template_type = 'Exhibition Hall'"

    execute "UPDATE templates SET template_sub_type = 'boothHall' where template_sub_type = 'Booth - Hall Format'"
    execute "UPDATE templates SET template_sub_type = 'knowledge_knowledgeLibrary' where template_sub_type = 'Knowledge Center - Knowledge Library'"
    execute "UPDATE templates SET template_sub_type = 'knowledge_tagList' where template_sub_type = 'Knowledge Center - Tag List'"
    execute "UPDATE templates SET template_sub_type = 'exhibition_hall' where template_sub_type = 'Exhibition Hall - Booth List'"
    execute "UPDATE templates SET template_sub_type = 'exhibition_hallsList' where template_sub_type = 'Exhibition Hall - Halls List'"
    execute "UPDATE templates SET template_sub_type = 'exhibition_boothList' where template_sub_type = 'Exhibition Hall - All Booth List'"
    execute "UPDATE templates SET template_sub_type = 'main_hall' where template_sub_type = 'Main Hall'"
  end
end
