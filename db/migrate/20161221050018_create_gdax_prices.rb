class CreateGdaxPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :gdax_prices do |t|
      t.datetime :start, unique: true
      t.bigint :start_timestamp, unique: true
      t.float :low
      t.float :high
      t.float :open
      t.float :close
      t.float :volume

      t.timestamps
    end
  end
end
