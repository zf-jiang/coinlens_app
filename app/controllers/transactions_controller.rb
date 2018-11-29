require 'httparty'
class TransactionsController < ApplicationController
  before_action :setevent
  
  def setevent
	@user = User.find(params[:user_id])
  end

  def index
    @user = User.find(params[:user_id])
    @total = 0
    @transactions = @user.transactions
    @arrayd = Array.new
    @transactions.each do |t|
      coin_name = Coin.find(t.coin_id).name
      id = Coin.find(t.coin_id).web_id
      link = URI.join("https://api.coinmarketcap.com/v1/ticker/",id)
      response = HTTParty.get(link,
                :headers =>{'Content-Type' => 'application/json'})
      price = response[0]["price_usd"]
      value = price.to_f.round(2) * t.amount
      @total = @total + value
      coin_arr = [coin_name, value]
      @arrayd.push(coin_arr)
    end
  end

  def new
  	@coins = Coin.all
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

  def edit
  	@transaction = @user.transactions.find(params[:id])
  end

  def update
  	@transaction = @user.transactions.find(params[:id])

  	if @transaction.save(transaction_params)
  		flash[:success] = "Updated!"
  		redirect_to :action => :index
  	else
  		flash.now[:danger] = "Amount cannot be blank."
  		render :action => :new
  	end
  end

  def destroy
  	@transaction = @user.transactions.find(params[:id])
  	@transaction.destroy
  	redirect_to :action => :index
  end

 private
 	def transaction_params
 		params.require(:transaction).permit(:user_id, :coin_id, :amount)
 	end
 end