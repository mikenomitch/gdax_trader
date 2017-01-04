class AddIndexToGdaxPricesTimes < ActiveRecord::Migration[5.0]
  def change
    add_index :gdax_prices, :start, unique: true
    add_index :gdax_prices, :start_timestamp, unique: true
  end
end
