desc 'tests out that the coinbase exchange gem works'
require 'coinbase/exchange'

namespace :gdax do
  task :sandbox_check => [:environment] do
    sandbox_api = CoinbaseApi .sandbox

    sandbox_api.last_trade(product_id: "BTC-USD") do |resp|
      p "Spot Rate: $ %.2f" % resp.price
    end
  end

  task :get_history => [:environment] do
    GdaxPrice.makePriceHistoryCall
  end

  task :history => [:environment] do
    api = CoinbaseApi.real_api

    api.price_history(
      start: (Time.now - 691.days).iso8601,
      end: (Time.now - 690.days - 18.hours).iso8601,
      granularity: 60
    ) do |resp|
      p resp
    end
  end

  task :price_check => [:environment] do
    api = CoinbaseApi.real_api

    api.last_trade(product_id: "BTC-USD") do |resp|
      p "Spot Rate: $ %.2f" % resp.price
    end
  end

  task :buy_minimum => [:environment] do
    api = CoinbaseApi.real_api

    api.last_trade(product_id: "BTC-USD") do |resp|
      p "Spot Rate: $ %.2f" % resp.price

      api.bid(0.01, resp.price) do |resp|
        p "Order ID is #{resp.id}"
      end
    end
  end

  task :sell_minimum => [:environment] do
    api = CoinbaseApi.real_api

    api.last_trade(product_id: "BTC-USD") do |resp|
      p "Spot Rate: $ %.2f" % resp.price
      asking_price = resp.price - 0.01
      p "asking_price - #{asking_price}"

      api.ask(0.01, asking_price) do |resp|
        p "Order ID is #{resp.id}"
      end
    end
  end
end
