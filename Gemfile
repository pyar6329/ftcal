source "https://rubygems.org"

ruby "2.3.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "4.2.5"
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.1.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use http Clients
# gem 'httpclient'

# login settings
gem "devise"
gem "omniauth"
gem "omniauth-google-oauth2"

# google API
gem "google-api-client", "~> 0.8.6"
# gem 'google_calendar'
gem "chronic"

# i18n
gem "i18n-js", ">= 3.0.0.rc11"
gem "http_accept_language"

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem "sqlite3"

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug"

  # BDD
  gem "rspec-rails"
  gem "factory_girl_rails"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 2.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-commands-rspec"

  # Debugger
  gem "pry"
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-stack_explorer"
  gem "better_errors"
  gem "binding_of_caller"
  gem "hirb"
  gem "hirb-unicode"

  # guard gems
  gem "guard-rspec"
  gem "guard-livereload"
  gem "rb-fsevent"

  # secret keys
  gem "dotenv-rails"

  # chrome extension
  gem "meta_request"
end

group :test do
  # BDD
  gem "fuubar"
  gem "ffaker"
  gem "shoulda-matchers"
  gem "capybara"
  gem "poltergeist"
  gem "launchy"
  gem "database_cleaner"

  # test-webservices
  gem "simplecov", require: false
  gem "coveralls", require: false
  gem "codecov", require: false
end

# heroku settings
group :production do
  gem "rails_12factor"
  gem "pg"
  gem "unicorn"
end
