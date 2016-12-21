desc 'tests out that the coinbase exchange gem works'
require 'coinbase/exchange'

# COINBASE EXCHANGE API MAKER
# TODO - move somewhere else

module ApiMaker
  @api_key = ENV['COINBASE_API_KEY']
  @api_secret = ENV['COINBASE_API_SECRET']
  @api_pass = ENV['COINBASE_API_PASS']
  @api_url = ENV['COINBASE_API_URL']
  @api_sandbox_url = ENV['COINBASE_API_SANDBOX_URL']

  def self.real_api
    @api ||= Coinbase::Exchange::Client.new(
      @api_key,
      @api_secret,
      @api_pass,
      api_url: @api_url
    )

    @api
  end

  def self.sandbox_api
    @sandbox ||= Coinbase::Exchange::Client.new(
      @api_key,
      @api_secret,
      @api_pass,
      api_url: @api_sandbox_url
    )

    @sandbox
  end
end



# TASKS
namespace :gdax do
  task :sandbox_check do
    sandbox_api = ApiMaker.sandbox

    sandbox_api.last_trade(product_id: "BTC-USD") do |resp|
      p "Spot Rate: $ %.2f" % resp.price
    end
  end

  task :history do
    api = ApiMaker.real_api

    api.price_history(
      start: (Time.now - 691.days).iso8601,
      end: (Time.now - 690.days - 18.hours).iso8601,
      granularity: 60
    ) do |resp|
      p resp
    end
  end

  task :price_check do
    api = ApiMaker.real_api

    api.last_trade(product_id: "BTC-USD") do |resp|
      p "Spot Rate: $ %.2f" % resp.price
    end
  end

  task :buy_minimum do
    api = ApiMaker.real_api

    api.last_trade(product_id: "BTC-USD") do |resp|
      p "Spot Rate: $ %.2f" % resp.price

      api.bid(0.01, resp.price) do |resp|
        p "Order ID is #{resp.id}"
      end
    end
  end

  task :sell_minimum do
    api = ApiMaker.real_api

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