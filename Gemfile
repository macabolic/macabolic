source 'http://rubygems.org'

#gem 'rails', '3.0.3'
gem 'rails', '3.0.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Install Paperclip
gem 'paperclip', '~> 2.4'

# Install Devise
gem 'devise', '>= 1.2'

# Install Omniauth authentication module
gem 'omniauth', '>= 0.2'
gem 'omniauth-facebook'
gem 'omniauth-openid'
gem 'omniauth-twitter'

# Install will_paginate do perform pagination in Admin page
# will_paginate is kept for Sunspot Solr 
# For the rest, due to a conflict with kaminari which is required by active_admin
gem 'will_paginate', '3.0.pre2'
gem 'kaminari'

# Include jQuery for doing some AJAX in front end
#gem 'jquery-rails'
gem 'jquery-rails', '>= 1.0.3'

# Gravatar API
gem 'gravatar-ultimate'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Use Sunspot for full-text search
gem 'sunspot_rails'
gem 'sunspot_solr'

# Handle RESTful API
gem 'httparty'

# Generate permalink
#gem 'has_permalink'

# Generate error messages
gem 'dynamic_form'

# Admin console
gem 'activeadmin'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
 group :development, :test do
   # gem 'webrat'
	gem 'progress_bar'
	gem 'sqlite3-ruby', :require => 'sqlite3'
 end

# Use MySQL
group :test, :production do
	#gem 'mysql2'
	gem 'progress_bar'
	gem 'ruby-mysql'
	gem 'rmagick'
end