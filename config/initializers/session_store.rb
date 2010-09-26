# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_macabolic_session',
  :secret      => 'e479447ca3d59059fb43d35e05b516eb8cce5c679462f1e87d3dc12877c1c6c05fb632c4bc13dc5408a3834fd0e4be7e8f964503cf1d4622f9be2d775f685a41'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
