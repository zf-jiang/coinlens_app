class Coin < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :symbol
  validates_presence_of :web_id
end
