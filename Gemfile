source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'rake'
gem 'mysql2'
gem 'addressable'
gem 'devise', '1.5.3'
gem 'whenever'
gem 'active_scaffold'
gem 'haml', '3.1.4'
gem 'sass', '3.1.12'
gem 'sprockets'
gem 'sass-rails', '3.1.5'
gem 'coffee-rails'
gem 'bower-rails'
gem 'unicorn'


# fixme: load during deployment only
gem 'capistrano'
gem 'capistrano-unicorn', :require => false

gem 'recaptcha',
  :require => 'recaptcha/rails'

gem 'exception_notification', :require => 'exception_notifier'


gem 'transitions',
  :require => ["transitions", "active_record/transitions"]

gem 'will_paginate', '3.0.3'
gem 'will_paginate-bootstrap'

# OTP toolbox
gem 'rotp', '~> 1.3.0'

# QR Code generation
gem 'qrencoder'

# IBAN format validations
gem 'iban-tools'

gem 'delayed_job'

# CSS toolbox
gem 'bourbon'
gem 'less-rails'

# File attachment with database storage support
gem 'paperclip', 
  :git => 'https://github.com/patshaughnessy/paperclip.git'

# Apple push notifications
gem 'apn_on_rails',
  :git => 'https://github.com/natescherer/apn_on_rails.git',
  :branch => 'rails3'

group :test do
  gem 'minitest-reporters'
  gem 'mocha', :require => false
  gem 'factory_girl_rails', '1.7.0'
end

group :assets do
  gem 'uglifier'
  gem 'execjs'
  gem 'therubyracer'
end
