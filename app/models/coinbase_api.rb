class CoinbaseApi
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
