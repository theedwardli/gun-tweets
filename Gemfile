source 'https://rubygems.org'

# Use Sinatra to build our application
gem 'sinatra'
# Use ActiveRecord
gem "activerecord"
gem "sinatra-activerecord"
# Use Postgres as the database
gem 'pg'


group :development, :test do
  # Configure environment variables
  gem 'dotenv'
  # Reload server
  gem 'shotgun'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  # Send logs to STDOUT
  gem 'rails_12factor', group: :production
end

