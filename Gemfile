source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.1', '>= 5.1.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Ensure sprockets ~> 3.7.2 due to CVE-2018-3760
gem 'sprockets', '~> 3.7.2'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Use Puma as the app server
  gem 'puma', '~> 3.12', '>= 3.12.6'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "capistrano", "~> 3.10", require: false
  gem 'capybara', '~> 2.18', '>= 2.18.0'
  gem 'capybara-selenium', '>= 0.0.6'
  gem 'chromedriver-helper', '>= 2.1.0'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bumbler'
  gem 'xray-rails', '>= 0.3.1'
end

group :production, :development do
  # Use Postgres by default
  gem 'pg', '~> 0.18'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'hyrax', github: 'samvera/hyrax'

group :development, :test do
  gem 'bixby'
  gem 'solr_wrapper', '>= 0.3'
end

gem 'devise', '>= 4.7.1'
gem 'devise-guests', '~> 0.6', '>= 0.6.1'
gem 'jquery-rails', '>= 4.4.0'
gem 'rsolr', '>= 1.0'
group :development, :test do
  gem 'bootsnap'
  gem 'factory_bot_rails', '>= 4.11.1'
  gem 'fcrepo_wrapper'
  gem 'rspec-its'
  gem 'rspec-rails', '>= 3.8.0'
end

gem 'webpacker', '~> 4.0.2.0.0'

group :test do
  # Use sqlite3 as the database in test
  gem 'codeclimate-test-reporter', '>= 1.0.8'
  gem 'database_cleaner'
  gem 'fakefs', require: 'fakefs/safe'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', '>= 0.13.0'
  gem 'sqlite3'
end

gem 'config'

gem 'hydra-works', github: 'avalonmediasystem/hydra-works', branch: 'av_characterization'
# Last revision before version 0.6 was released.  This can be removed once this gem is upgraded to hyrax master (3.0.0.beta2) or support for 0.6 is backported to hyrax 2.x
gem 'iiif_manifest', '~> 1.0'
gem 'riiif', '~> 1.7', '>= 1.7.1'

gem 'active_encode', github: 'samvera-labs/active_encode'
gem 'hyrax-active_encode', github: 'samvera-labs/hyrax-active_encode', branch: 'hyrax_master'
gem 'hyrax-batch_ingest', github: 'samvera-labs/hyrax-batch_ingest', branch: 'cjcolvar-patch-1'
gem 'hyrax-iiif_av', github: 'samvera-labs/hyrax-iiif_av', branch: 'hyrax_master'
gem 'license_header'
gem 'react-rails', '>= 2.4.7'

# Install the bundle --with aws if using any AWS service
group :aws, optional: true do
  gem 'aws-sdk', require: false
end

gem 'rack-cors', '>= 1.0.5'
