class AddTickerMessageToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :ticker_message, :text
  end
end
