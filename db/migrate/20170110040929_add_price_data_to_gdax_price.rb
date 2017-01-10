class AddPriceDataToGdaxPrice < ActiveRecord::Migration[5.0]
  def change
    add_column :gdax_prices, :price_ago_five, :float
    add_column :gdax_prices, :price_ago_ten, :float
    add_column :gdax_prices, :price_later_five, :float
    add_column :gdax_prices, :price_later_ten, :float
    add_column :gdax_prices, :price_speed_a, :float
    add_column :gdax_prices, :price_speed_b, :float
    add_column :gdax_prices, :price_accel_a, :float
    add_column :gdax_prices, :price_accel_b, :float
    add_column :gdax_prices, :price_jerk_a, :float
    add_column :gdax_prices, :price_jerk_b, :float
  end
end
