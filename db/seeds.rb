# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'httparty'
require 'json'
require 'uri'

link = "https://api.coinmarketcap.com/v2/ticker/?limit=100&structure=array"
#"https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
response = HTTParty.get(link,
	:headers => {#'X-CMC_PRO_API_KEY' => 'c98d923d-ca3c-4a2b-85a1-37b376a3aeda',
				 'Content-Type' => 'application/json'})
response["data"].each do |d|
	Coin.create!(
		name: d['name'],
		symbol: d['symbol'],
		web_id: d['website_slug']
		)
end

puts "CoinMarketCap API successfully seeded into database."