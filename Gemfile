source 'https://rubygems.org'

gem 'sinatra'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Reload server
  gem 'shotgun'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
	# Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :production do
  # Setup db
  gem 'pg'
  # Send logs to STDOUT
  gem 'rails_12factor', group: :production
end

