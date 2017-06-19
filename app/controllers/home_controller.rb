class HomeController < ApplicationController
  def index
  end
  
  def load
    Scraper.new.load
    redirect_to root_path
  end
end
