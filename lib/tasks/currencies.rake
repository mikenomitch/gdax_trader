desc 'gets currency data and loads it into the db'
require 'open-uri'
require 'set'

namespace :currencies do
  CURRENCIES_TO_GET = [
    'EUR', # euro
    'JPY', # japan
    'CNH', # offshore china
    'XAU', # gold
    'RUB', # russia
  ]

  task :get_zips => [:environment] do
    USD_FIRST_CURRENCIES = [
      'JPY',
      'CNH',
      'RUB',
    ]

    YEARS_TO_GET = ['2015', '2016']

    WEEK_STRINGS = [
      'Week1',
      'Week2',
      'Week3',
      'Week4',
      'Week5'
    ]

    MONTH_STRINGS = [
      '01%20January',
      '02%20February',
      '03%20March',
      '04%20April',
      '05%20May',
      '06%20June',
      '07%20July',
      '08%20August',
      '09%20September',
      '10%20October',
      '11%20November',
      '12%20December'
    ]

    BASE_URL = 'http://ratedata.gaincapital.com/'

    # mmmm gross code ;)

    # http://ratedata.gaincapital.com/2016/02%20February/AUD_CHF_Week1.zip
    CURRENCIES_TO_GET.each do |cur|
      YEARS_TO_GET.each do |year|
        WEEK_STRINGS.each do |week|
          MONTH_STRINGS.each do |month|
            non_url_part = USD_FIRST_CURRENCIES.include?(cur) ?
              "#{year}/#{month}/USD_#{cur}_#{week}.zip" :
              "#{year}/#{month}/#{cur}_USD_#{week}.zip"

            url = "#{BASE_URL}#{non_url_part}"
            p "getting from #{url}..."

            begin
              open("./currency_histories/#{non_url_part.gsub('/','_')}", 'w+b') do |file|
                p "writing..."
                file << open(url).read
              end

            rescue => e
              puts '======================'
              puts "erroerd out on: #{url}"
              puts '======================'
            end
            p "wrote it."
          end
        end
      end
    end
  end

  task :load_from_aws => [:environment] do
    puts "Hai"
  end

  task :load_from_csvs => [:environment] do
    require 'csv'

    @logger = Logger.new("#{Rails.root}/log/load_from_csvs.log")

    CURRENCIES_TO_GET.each do |currency|
      currency_files = Dir.entries("./currency_histories").select do |f|
        f =~ /csv/ && f.include?(currency)
      end

      key_list = ['lt_id','c_dealable','currency_pair','time','bid','ask']
      currency_files.each do |file_name|
        csv_text = File.read("./currency_histories/#{file_name}")
        csv = CSV.parse(csv_text, :headers => true)
        @taken_times = Set.new

        csv.each do |row|
          begin
            # this could be better :(
            modded_row = row.map.with_index { |v, i|
              [key_list[i], v[1]]
            }.to_h

            modded_row['time'] = modded_row['time'].to_datetime
            modded_row['timestamp'] = modded_row['time'].to_time.to_i


            if !@taken_times.include?(modded_row['timestamp'])
              CurrencyPrice.create(modded_row)
              @taken_times.add(modded_row['timestamp'])
            else
              @logger.info("skipping row: #{modded_row} since it was a dupe time")
            end
          rescue => e
            @logger.error(e)
          end
        end
        @logger.info('finished file', "./currency_histories/#{file_name}")
      end
    end
  end
end
