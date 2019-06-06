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

link = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info"
pairings = File.read('db/pairings.txt').split("\n")
pairings.each do |p| 
	response = HTTParty.get(
		link, 
		:query => {'symbol' => p}, 
		:headers => {'X-CMC_PRO_API_KEY' => ENV["CMC_API_KEY"], 'Content-Type' => 'application/json'}
		)
	if response["status"]["error_code"] == 0
		Coin.create!(
			name: response["data"][p]['name'], 
			symbol: response["data"][p]['symbol'], 
			web_id: response["data"][p]['slug']
			)
		puts "#{p} has been seeded into the database."
	else
		puts "#{p} is not in the CoinMarketCap system."
	end
	sleep(1) # Too many API calls
end

puts "CoinMarketCap API successfully seeded into database."