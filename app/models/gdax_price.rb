class GdaxPrice < ApplicationRecord
  attr_accessor :start, :start_timestamp, :low, :high, :open, :close, :volume
  validates :start, uniqueness: true

  EARLIEST_TIME = 691.days.ago
  TIME_GAP = 4.hours

  private

  def self.latest
    GdaxPrice.maximum("start") || EARLIEST_TIME
  end

  def self.parseAndCreate(responseVal)
    gdp = GdaxPrice.new()
    [:low, :high, :open, :close, :volume].each do |attr|
      gdp[attr] = responseVal[attr.to_s].to_f
    end
    gdp[:start] = responseVal['start'].to_datetime
    gdp[:start_timestamp] = responseVal['start'].to_time.to_i
    gdp.save
    gdp
  end

  def self.makePriceHistoryCall
    api = CoinbaseApi.real_api
    prices_start = GdaxPrice.latest
    prices_end = prices_start + TIME_GAP

    calls_end = Time.now - 10.days

    i = 0
    while(prices_start < calls_end) do
      prices_start = GdaxPrice.latest
      prices_end = prices_start + TIME_GAP
      api.price_history(
        start: prices_start.iso8601,
        end: prices_end.iso8601,
        granularity: 60
      ) do |resp|
        puts "CALL NUMBER #{i}"
        i = i + 1
        puts resp
        resp.map { |r| GdaxPrice.parseAndCreate(r)}
      end
      sleep 1.3
    end
  end
end
