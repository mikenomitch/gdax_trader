desc 'gets currency data and loads it into the db'
require 'coinbase/exchange'

namespace :gdax do
  task :check => [:environment] do
    puts 'hey dere'
  end
end
