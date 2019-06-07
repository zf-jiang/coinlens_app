require 'httparty'
require 'time'
require 'uri'

class TransactionsController < ApplicationController
  before_action :setevent
  
  def setevent
  	@user = User.find(params[:user_id])
    @api_link = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest'
  end

  # REST Api call
  def pullApi(symbol)
    response = HTTParty.get(
      @api_link,
      :query => {'symbol' => symbol}, 
      :headers => {'X-CMC_PRO_API_KEY' => ENV["CMC_API_KEY"], 'Content-Type' => 'application/json'}
    )
  end

  def index
  	@total = 0
  	@transactions = @user.transactions
  	@txarray = Array.new
  	@transactions.each do |t|
  		coin_name = Coin.find(t.coin_id).name
  		symbol = Coin.find(t.coin_id).symbol
  		data = pullApi(symbol)
  		price = data['data'][symbol]['quote']['USD']['price']
  		value = price.to_f * t.amount
  		@total = @total + value
  		transaction_arr = [coin_name, value]
  		@txarray.push(transaction_arr)
  	end
  	@rounded_total = @total.round(2)
  end

  def new
  	@coins = Coin.order(:name)
  	@transaction = @user.transactions.build
  end

  def create
  	@transaction = @user.transactions.new(transaction_params)

  	if @transaction.save
  		flash[:success] = "Successfully added to your portfolio."
  		redirect_to :action => :index
  	else
  		render 'new'
  	end
  end

  def show
  	transaction = @user.transactions.find(params[:id])
  	@coin_name = Coin.find(transaction.coin_id).name
  	@coin_symbol = Coin.find(transaction.coin_id).symbol
    @data = pullApi(@coin_symbol)
  	@rank = @data['data'][@coin_symbol]['cmc_rank']
  	@price = @data['data'][@coin_symbol]['quote']['USD']['price'].to_f.round(2)
  	@day_change = @data['data'][@coin_symbol]['quote']['USD']["percent_change_24h"]
  	@curr_holding = transaction.amount
  	@value = (@price * @curr_holding).round(2)

  	day_chart_api = "https://min-api.cryptocompare.com/data/histoday?fsym=#{@coin_symbol}&tsym=USD&limit=7"
  	@day_response = HTTParty.get(day_chart_api,
    		   		:headers =>{'Content-Type' => 'application/json'})
  	@histoday_arr = Array.new
  	(0..7).each do |i|
  			date = Time.at(@day_response["Data"][i]["time"]).strftime("%Y-%m-%d")
  			close = @day_response["Data"][i]["close"]
  			date_arr = [date,close]
  			@histoday_arr.push(date_arr)
  	end
	
  	hour_chart_api = "https://min-api.cryptocompare.com/data/histohour?fsym=#{@coin_symbol}&tsym=USD&limit=10"
  	@hour_response = HTTParty.get(hour_chart_api,
    		   		 :headers =>{'Content-Type' => 'application/json'})
  	@histohour_arr = Array.new
  	(0..10).each do |i|
  		date = Time.at(@hour_response["Data"][i]["time"]).strftime("%c")
  		close = @hour_response["Data"][i]["close"]
  		date_arr = [date,close]
  		@histohour_arr.push(date_arr)
  	end
  end


  def edit
  	@transaction = @user.transactions.find(params[:id])
  end

  def update
  	@transaction = @user.transactions.find(params[:id])

  	if @transaction.update(transaction_params)
  		flash[:success] = "Successfully updated your portfolio."
  		redirect_to :action => :index
  	else
  		flash.now[:danger] = "Amount cannot be blank."
  		render :action => :new
  	end
  end

  def destroy
  	@transaction = @user.transactions.find(params[:id])
  	if @transaction.destroy
  		flash[:success] = "Successfully removed from your portfolio."
  	end
  	redirect_to :action => :index
  end

 private
  	def transaction_params
  		params.require(:transaction).permit(:user_id, :coin_id, :amount)
  	end
end