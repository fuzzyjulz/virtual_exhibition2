class AddProducerRole < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM roles WHERE name  = 'host'"
    execute "INSERT INTO roles (name) VALUES ('producer')"
  end
  
  def self.down
    execute "DELETE FROM roles WHERE name  = 'producer'"
  end
end
