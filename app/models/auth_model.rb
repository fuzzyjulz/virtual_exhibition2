class AuthModel < ActiveRecord::Base
  resourcify
  
  has_and_belongs_to_many :event
  
  after_create do |authModel|
    AuthModel.createClassMethod(authModel)
  end
  
  def self.createClassMethod(authModel)
    (class << self; self; end).send(:define_method, authModel.code) { AuthModel.find_by(code: authModel.code) }
  end

  AuthModel.all.each do |authModel|
    createClassMethod(authModel)
  end
end
