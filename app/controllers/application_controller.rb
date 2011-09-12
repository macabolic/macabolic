class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_locale
    I18n.locale = params[:locale]
  end

  def self.default_url_options(options={})
    options.merge({ :locale => I18n.locale })
  end
  
end
