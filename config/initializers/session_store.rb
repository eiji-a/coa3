# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_coa3_session',
  :secret      => '226c8d362bdee09d3a18fe972b6bf4b465f40cbb97b9c8cf6ac4393a2d67feef0df694cd419ef8c598bd27246bcf0cd3591d29f0c18c9c6472633e63568334bf',
  :cookie_only => false
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
