source 'https://rubygems.org'

ruby '2.3.1'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.0'
gem 'validates_timeliness', '~> 4.0'
gem 'ancestry'
gem 'abstraction'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'rails-controller-testing' # Gem necessária para usar o método assing nos testes com RSpec
  gem 'factory_girl_rails', require: false
  gem 'faker'
  gem 'shoulda-matchers', require: true
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'database_cleaner'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
