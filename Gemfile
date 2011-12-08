source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'nokogiri'
gem "SgfParser", :path => "lib/assets/gems/SgfParser"
gem 'ffaker'
gem 'activeadmin'
gem "meta_search",    '>= 1.1.0.pre'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'pg'
end

group :test, :development do  
  gem 'sqlite3'
end

gem 'devise', '1.4.9'

gem "rspec-rails", :group => [:test, :development]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem "factory_girl_rails"
  gem "capybara"
  gem 'spork', '> 0.9.0.rc'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-pow'
  gem 'growl_notify'
  gem "spork", "> 0.9.0.rc"
end
