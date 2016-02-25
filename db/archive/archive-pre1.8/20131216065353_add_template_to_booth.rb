class AddTemplateToBooth < ActiveRecord::Migration
  def change
    add_reference :booths, :template, index: true
  end
end
