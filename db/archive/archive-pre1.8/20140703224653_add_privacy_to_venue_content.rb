class AddPrivacyToVenueContent < ActiveRecord::Migration
  def change
    add_column :venues, :privacy, :integer
    add_column :contents, :privacy, :integer
    
    Venue.all.each do |venue|
      venue.private_scope!
      venue.save!
    end
    Content.all.each do |content|
      content.privacy = :private_scope
      content.save!(validate: false) 
    end
  end
end
