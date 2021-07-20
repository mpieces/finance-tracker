class UsersController < ApplicationController

  def my_portfolio
    @tracked_stocks = current_user.stocks 
  end

  def show_friends
    @friends = current_user.friends
  end

  def search
    # first step:
    # render json: params[:friend]
    if params[:friend].present?
      @friend = params[:friend]
      if @friend
        respond_to do |format| 
          # partial has to have same folder name as controller name! 
          format.js { render partial: 'users/friend_result' }
        end
      else
        respond_to do |format| 
          flash.now[:alert] = "Couldn't find user"
          format.js { render partial: 'users/friend_result' }
        end 
      end
    else
      respond_to do |format| 
          flash.now[:alert] = "Please enter a friend name or email to search"
          format.js { render partial: 'users/friend_result' }
        end     
    end
  end

end
