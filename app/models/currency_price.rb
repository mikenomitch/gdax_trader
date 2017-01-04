class CurrencyPrice < ApplicationRecord
  validates :start, uniqueness: true
end
