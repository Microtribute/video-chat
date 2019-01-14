#require 'rack/ssl'
Lawdingo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Open emails with letter_opener
  config.action_mailer.delivery_method = :letter_opener

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Allow pass debug_assets=true as a query parameter to load pages with unpackaged assets
  config.assets.allow_debugging = true

  # Expands the lines which load the assets
  config.assets.debug = true

  # config.middleware.use('SpoofIp', '64.71.24.19') # California
  # config.middleware.use('SpoofIp', '159.247.160.80') # Connecticut  http://www.cga.ct.gov/
  # config.middleware.use('SpoofIp', '207.66.0.2') # New Mexico  http://legis.state.nm.us/

  # config.force_ssl = true
  # config.after_initialize do
  #   Debugger.start
  # end
end
