source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'mysql2'

#RottenTomatoes
gem 'rottentomatoes'

gem "haml", ">= 3.0.0"
gem "haml-rails"
gem "jquery-rails"
gem "omniauth", ">= 0.2.0"

gem "exception_notification", :require => 'exception_notifier'

group :development do
  # DEPLOYMENT
  gem 'capistrano'
end

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem "rspec-rails"
  gem "mocha"
  gem "cucumber-rails"
  gem "capybara"
  gem "jslint_on_rails" # Javascript validator
end

group :assets do
  gem 'sass-rails', " ~> 3.1.0"
  gem 'coffee-rails', " ~> 3.1.0"
  gem 'uglifier'
end

