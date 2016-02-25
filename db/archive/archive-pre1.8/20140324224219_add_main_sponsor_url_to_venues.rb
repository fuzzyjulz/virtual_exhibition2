class AddMainSponsorUrlToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :main_sponsor_url, :string
  end
end
