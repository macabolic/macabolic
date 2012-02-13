class Users::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    logger.info "overloaded the after_sign_in_path_for..."
    #home_index_path
    root_url
  end

end