class AddPartnerUrlTypeToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :partner_url_type, :integer
  end
end
