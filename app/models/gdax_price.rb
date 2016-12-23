class GdaxPrice < ApplicationRecord
  attr_accessor :start, :start_timestamp, :low, :high, :open, :close, :volume
  validates :start, uniqueness: true

  EARLIEST_TIME = 691.days.ago
  TIME_GAP = 4.hours

  def self.my_logger
    @my_logger ||= Logger.new("#{Rails.root}/log/gdax_calls.log")
  end

  def self.info_log(str)
    puts str
    my_logger.info(str)
  end

  def self.error_log(str)
    puts str
    my_logger.info(str)
  end

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

    begin
      i = 0
      while(prices_start < calls_end) do
        prices_start = GdaxPrice.latest
        prices_end = prices_start + TIME_GAP
        api.price_history(
          start: prices_start.iso8601,
          end: prices_end.iso8601,
          granularity: 60
        ) do |resp|
          info_log "CALL NUMBER #{i}"
          i = i + 1
          info_log resp
          resp.map { |r| GdaxPrice.parseAndCreate(r)}
        end
        sleep 1.3
      end

      info_log 'DONE'

    rescue Exception => e
      error_log 'there was an error'
      error_log e
    end
  end
end
