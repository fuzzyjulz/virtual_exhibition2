# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
# puts 'DEFAULT USERS'
# user = User.find_or_create_by_email :email => ENV['ADMIN_EMAIL'].dup, :first_name => ENV['ADMIN_FNAME'].dup, :last_name => ENV['ADMIN_LNAME'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
# puts 'user: ' << user.email
# user.skip_confirmation
# user.add_role :admin

admin = User.new(
	email: 'jae.choi@commstrat.com.au',
	first_name: 'Jae', 
	last_name: 'Choi', 
  	password: '1qaz2wsx',
  	password_confirmation: '1qaz2wsx'
	)
admin.skip_confirmation!
admin.save!
admin.add_role :admin

booth_rep = User.new(
	email: 'jaekun.choi@gmail.com',
	first_name: 'Booth', 
	last_name: 'Rep', 
  	password: '1qaz2wsx',
  	password_confirmation: '1qaz2wsx'
	)
booth_rep.skip_confirmation!
booth_rep.save!
booth_rep.add_role :booth_rep


host = User.new(
	email: 'admin@industryjobsboard.com.au',
	first_name: 'Host', 
	last_name: 'Host', 
  	password: '1qaz2wsx',
  	password_confirmation: '1qaz2wsx'
	)
host.skip_confirmation!
host.save!
host.add_role :host

visitor = User.new(
	email: 'info@commstrat.com.au',
	first_name: 'Visitor', 
	last_name: 'Visitor', 
  	password: '1qaz2wsx',
  	password_confirmation: '1qaz2wsx'
	)
visitor.skip_confirmation!
visitor.save!
visitor.add_role :visitor
