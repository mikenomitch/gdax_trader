class CreateCurrencyPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :currency_prices do |t|
      t.integer :lt_id, limit: 8
      t.integer :timestamp, unique: true, limit: 8
      t.string :c_dealable
      t.string :currency_pair
      t.datetime :time, unique: true
      t.float :bid
      t.float :ask

      t.timestamps
    end

    add_index :currency_prices, :time, unique: true
    add_index :currency_prices, :timestamp, unique: true
  end
end
