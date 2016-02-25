class CreateContent < ActiveRecord::Migration
#Rollback SQL:
  
#  drop table contents;
#  drop table booths_contents;
#  drop table contents_halls;
#  drop table contents_tags;
#  delete from schema_migrations where version = '20140508045056';
#  alter table tags drop column featured;
#  alter table tags drop column venue_id;
#  alter table halls drop column welcome_video_content_id;
  
  def change
    create_new_tables
    #migrate_old_data #Migrations are no longer required, and will cause errors on the build. Prod is now past this point.
    remove_old_tables
  end
  
private
  def create_new_tables
    create_table :contents do |t|
      t.string :name
      t.string :short_desc
      t.text :description
      t.boolean :featured
      
      t.string :content_type
      t.string :external_id
      
      t.belongs_to :sponsor_booth
      t.belongs_to :owner_user
      t.timestamps
    end
    
    add_column :tags, :featured, :boolean
    add_column :tags, :venue_id, :integer, references: :venue
    add_column :halls, :welcome_video_content_id, :integer, references: :content
    
    create_join_table :booths, :contents do |t|
      t.index [:booth_id, :content_id]
      t.index [:content_id, :booth_id]
    end
    create_join_table :halls, :contents do |t|
      t.index [:hall_id, :content_id]
      t.index [:content_id, :hall_id]
    end
    create_join_table :contents, :tags do |t|
      t.index [:content_id, :tag_id]
      t.index [:tag_id, :content_id]
    end
  end
  
  
  
  def migrate_old_data
    Video.all.each do |video|
      content = Content.new(name: video.name, short_desc: video.short_desc, description: video.description, featured: video.featured,
        content_type: Content::CONTENT_TYPE[:youtube_video], external_id: video.yt_youtube_id,
        sponsor_booth: video.sponsor, owner_user: video.user)
      if video.hall
        content.halls << video.hall
      end
      video.booths.each do |booth|
        content.booths << booth
      end
      content.save!
    end
    
    Literature.all.each do |literature|
      content = Content.new(name: literature.name, short_desc: literature.short_desc, description: literature.description, featured: false,
        content_type: Content::CONTENT_TYPE[:resource], external_id: literature.file_url,
        sponsor_booth: nil, owner_user: literature.user)
      if literature.file
        content.resource_file = UploadedFile.new(image_type: UploadedFile::RESOURCE_FILE)
        content.resource_file.assets = literature.file
      end
      if literature.hall
        content.halls << literature.hall
      end
      literature.booths.each do |booth|
        content.booths << booth
      end
      content.save!
    end
    
    Presentation.all.each do |presentation|
      content = Content.new(name: presentation.name, short_desc: presentation.short_desc, description: presentation.description, featured: false,
        content_type: Content::CONTENT_TYPE[:slideshare], external_id: presentation.slideshare_id,
        sponsor_booth: nil, owner_user: presentation.user)
      if presentation.logo.present? && presentation.logo.assets.present?
        content.thumbnail_image = UploadedFile.new(image_type: UploadedFile::IMAGE_TYPE_THUMBNAIL)
        content.thumbnail_image.assets = presentation.logo.assets
      end
      if presentation.hall
        content.halls << presentation.hall
      end
      presentation.booths.each do |booth|
        content.booths << booth
      end
      content.save!
    end
    
    Hall.all.each do |hall|
      if hall.video.present?
        hall.welcome_video_content = Content.where(name: hall.video.name, description: hall.video.description, external_id: hall.video.yt_youtube_id)[0]
        hall.save!
      end
    end
  end
  
  
  
  def remove_old_tables
    drop_table :booths_forums
    drop_table :booths_partners
    drop_table :booths_videos
    drop_table :booths_literatures
    drop_table :booths_presentations
    drop_table :forums
    drop_table :videos
    drop_table :halls_sponsors
    drop_table :literatures_tags
    drop_table :literatures
    drop_table :presentations
    drop_table :partners
    drop_table :sponsors

    remove_column :halls, :video_id
  end
end
