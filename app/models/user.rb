class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
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

  def self.search(param)
    param.strip!
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

 # class method, so can remove User from before 'where' and add 'self'
  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  # to ensure that current user is not included in search results
  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def not_friends_with?(id_of_friend)
    # self refers to instance of the user
    !self.friends.where(id: id_of_friend).exists?
  end



end
