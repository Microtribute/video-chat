source 'http://rubygems.org'

gem 'rails', '3.1.4'
gem 'rake'#, '0.8.7'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'opentok'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "3.1.4"
  gem 'coffee-rails'#, "~> 3.1.4"
  gem 'uglifier'
end


#solr-sunspot
gem 'sunspot_rails' #fork for rails
gem 'sunspot_solr'  #Solr
gem 'progress_bar'  #for_re-index

group :test, :development do
  gem "sunspot-rails-tester" #for test
end

gem 'jquery-rails'
gem "therubyracer"
gem 'ios-checkboxes'
gem "paperclip", "~>2.3.8"
gem 'aws-s3'
gem "rabl"
gem "draper"
#gem 'pg'

gem 'stripe'
gem 'rack-ssl', :require => 'rack/ssl'
gem 'openssl-extensions', '1.1.0'
gem 'openssl-nonblock', '0.2.1'
gem 'client_side_validations'
gem 'twilio-ruby'
gem "newrelic_rpm", "~>3.1.1"
gem "simple_form"
gem 'geocoder'
gem 'letter_opener'
gem 'framey'
gem 'oauth'
gem 'haml-rails'
gem 'dynamic_sitemaps'

# Handling cron jobs
gem 'whenever', require: false

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :development do
  #gem 'ruby-debug19', :require => "ruby-debug"
  gem 'sqlite3'
  gem 'quiet_assets'
  gem 'thin'
  gem 'certified' # mac ssl error fix
end

group :test do
  # Pretty printed test output
  # gem 'turn', :require => false

  gem "capybara"
  gem 'database_cleaner'
  gem "factory_girl_rails"
  gem 'faker'
  gem "guard-bundler"
  gem "guard-rspec"
  gem "guard-spork"
  gem "mocha", require: false
  gem "timecop"
  gem 'rails3-generators' #mainly for factory_girl & simple_form at this point
  gem "rspec-rails"
  gem 'debugger' 
  gem 'shoulda'
  gem 'shoulda-matchers'
end

group :staging, :production do
  gem 'exception_notification'
end
