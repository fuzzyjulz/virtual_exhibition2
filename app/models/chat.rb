class Chat < ActiveRecord::Base
	belongs_to :from_user, :foreign_key => 'from_user_id', class_name: 'User'
	belongs_to :to_user, :foreign_key => 'to_user_id', class_name: 'User'
	belongs_to :chattable, polymorphic: true
	# belongs_to :chattable, :foreign_key => 'chattable_id', class_name: 'Booth'

	validates :from_user, associated: true, presence: true
	validates :message, presence: true

	attr_accessor :new

	def self.read_all_booth_user_chats booth_id
		where(:chattable_type => "Booth", :chattable_id => booth_id).update_all(:read => true)
	end
	def self.unread_count(booth)
    booth.chats.where(:read => [false, nil]).order(:created => :desc).size if booth.present?
	end
end
