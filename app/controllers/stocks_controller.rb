class StocksController < ApplicationController

  def search
    # byebug
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        respond_to do |format| 
          format.js { render partial: 'stocks/result' }
        end
      else
        respond_to do |format| 
          flash.now[:alert] = "#{params[:stock]} is not a valid symbol. Please enter a valid symbol to search"
          format.js { render partial: 'stocks/result' }
        end 
      end
    else
      respond_to do |format| 
          flash.now[:alert] = "Please enter a symbol to search"
          format.js { render partial: 'stocks/result' }
        end     
    end
  end
end
