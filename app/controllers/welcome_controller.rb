class WelcomeController < ApplicationController
  
  def index
    @registration = Registration.new
    @registration.first_name = "First Name"
    @registration.last_name = "Last Name"
    @registration.email_address = "Email Address"
  end
  
end
