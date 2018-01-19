source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'seed_dump'
gem 'whenever'

gem 'rack-cors', :require => 'rack/cors'

# GEMS for S3 File uploads to work
#------------------------------->
gem 'carrierwave', '~> 1.0'
gem "fog-aws"
#<-------------------------------

gem 'aws-sdk', '~> 3'

gem 'bulk_insert'

gem "paranoia", "~> 2.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
 
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'seed_dump'
# Manages application of security headers with many safe defaults
gem 'secure_headers'

gem 'scenic'
# Rack middleware for blocking & throttling
gem 'rack-attack'

group :production, :cron, :staging do # Cron env should have access to all production level gems.
  # Use PostgreSQL as the database for Active Record
  gem 'pg', '~> 0.20.0'
end
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # factory_girl is a fixtures replacement with a straightforward definition syntax.
  gem 'factory_girl_rails'
  gem 'to_factory'
  gem 'rails-controller-testing'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
