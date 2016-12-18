desc 'tests out that the coinbase exchange gem works'
require 'coinbase/exchange'

api_key = ENV['COINBASE_API_KEY']
api_secret = ENV['COINBASE_API_SECRET']
api_pass = ENV['COINBASE_API_PASS']
api_url = ENV['COINBASE_API_URL']
api_sandbox_url = ENV['COINBASE_API_SANDBOX_URL']

task :test_trade do
  sandbox_api = Coinbase::Exchange::Client.new(
    api_key,
    api_secret,
    api_pass,
    api_url: api_sandbox_url
  )

  sandbox_api.last_trade(product_id: "BTC-GBP") do |resp|
    p "Spot Rate: £ %.2f" % resp.price
  end
end
