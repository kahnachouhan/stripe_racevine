
class HomeController < ApplicationController

  def index
    @camps = (Stripe::Plan.all rescue [])
  end

end
