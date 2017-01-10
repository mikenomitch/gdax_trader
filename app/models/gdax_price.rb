class GdaxPrice < ApplicationRecord
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
    EARLIEST_TIME || GdaxPrice.maximum("start") || EARLIEST_TIME
  end

  def self.parse_and_create(responseVal)
    gdp = GdaxPrice.new()
    [:low, :high, :open, :close, :volume].each do |attr|
      gdp[attr] = responseVal[attr.to_s].to_f
    end
    gdp[:start] = responseVal['start'].to_datetime
    gdp[:start_timestamp] = responseVal['start'].to_time.to_i
    gdp.save
    gdp
  end

  def self.remove_duplicates_in_batches(batch_size)
    GdaxPrice.select(:id, :start_timestamp).find_in_batches(batch_size: batch_size).with_index do |a_batch, i|
      puts "batch number:", i
      next if i < 60

      a_batch.each do |gdax_price|
        matching_timestamp = a_batch.select do |gdp|
          gdp.start_timestamp == gdax_price.start_timestamp
        end

        if matching_timestamp.count > 1
          to_remove = matching_timestamp.max_by{|p| p.id}
          puts "destroying", to_remove.attributes["id"]
          to_remove.delete
        end
      end
    end
  end

  def self.naive_remove_duplicates
    p "starting the first removal run"
    self.remove_duplicates_in_batches(4793)
    p "starting the second"
    self.remove_duplicates_in_batches(5237)
    p "donezo"
  end

  def self.make_price_history_call
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
          resp.map { |r| GdaxPrice.parse_and_create(r)}
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
