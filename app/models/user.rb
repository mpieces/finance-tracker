class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # check if the stock is already being tracked by this current user
  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    # now work with if it does exist
    stocks.where(id: stock.id).exists?
  end

  # is user tracking less than 10 stocks?
  def under_stock_limit?
    # B/c in User class, do not need to have user.stocks.count
    stocks.count < 10
  end
  
  # stock that's NOT already tracked (false)
  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end


end
