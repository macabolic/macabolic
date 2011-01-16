class WelcomeController < ApplicationController
  def index
    @registration = Registration.new
  end

end
