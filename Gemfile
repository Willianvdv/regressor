source 'https://rubygems.org'

gem 'rails'
gem 'sprockets-rails'
gem 'sprockets'
gem 'sass-rails'
gem 'arel'
gem 'rack'
gem 'active_model_serializers', '~> 0.8.3'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', github: "rails/coffee-rails"

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'stronger_parameters', '~> 2.4.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', github: 'rails/web-console'
  gem 'spring-commands-rspec'
  gem 'guard-rspec', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'omniauth'
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth-github'
gem 'friendly_id'
