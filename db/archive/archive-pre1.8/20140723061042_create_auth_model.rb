class CreateAuthModel < ActiveRecord::Migration
  def change
    create_table :auth_models do |t|
      t.string :name
      t.string :code
    end
    
    create_join_table :venues, :auth_models do |t|
      t.index [:auth_model_id, :venue_id]
      t.index [:venue_id, :auth_model_id]
    end
    
    migrate_data
  end
  def migrate_data
    linkedin = AuthModel.new(name: "LinkedIn", code:"linkedin")
    linkedin.save!
    AuthModel.new(name: "Facebook", code:"facebook").save!
    direct = AuthModel.new(name: "Direct", code:"direct")
    direct.save!
    Venue.all.each do |venue|
      venue.auth_models << linkedin
      venue.auth_models << direct
      venue.save!(validate: false)
    end
  end
end
