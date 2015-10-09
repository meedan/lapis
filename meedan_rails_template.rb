# Meedan Rails Template
# Usage: rails new <your application name> -m <path to this file>
# Reference: http://guides.rubyonrails.org/rails_application_templates.html

require 'tempfile'
require 'yaml'

# Helper function

def generate_files(*paths)
  paths.each do |path|
    puts "Generating #{path}..."
    file path, File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src', path)), force: true
  end
end

# Read configuration

CONFIG = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), 'config.yml'))

# Gems

gem 'rails', '4.0.9'
gem 'sqlite3'
gem 'jbuilder', '~> 1.2'
gem 'webmock'
gem 'mocha'
gem 'simplecov', require: false, group: :test
gem 'railroady'
gem 'airbrake'
gem 'codeclimate-test-reporter', group: :test, require: nil
gem 'awesome_print', require: false, group: :development
gem 'gem-licenses'
gem 'logstasher'
gem 'auto_localize', '0.1'
gem 'thin'
gem 'protected_attributes'

# Test structure

generate_files 'test/test_helper.rb', 'lib/sample_data.rb'

# API key

generate_files 'app/models/api_key.rb', 'test/models/api_key_test.rb'

# Documentation

generate_files 'doc/Makefile'

# Git

git :init
post_commit = File.join(File.expand_path(File.dirname(__FILE__)), 'src/git/post-commit')
contents = File.read(post_commit)
f = Tempfile.new('post-commit')
f.write contents.gsub('%slack_webhook%', CONFIG['slack_webhook']).gsub('%slack_channel%', CONFIG['slack_channel']).gsub('%code_climate_token%', CONFIG['code_climate_token'])
f.close
file '.git/hooks/post-commit', File.read(f.path)
file '.git/hooks/pre-commit', File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src/git/pre-commit'))
file '.gitignore', File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src/git/ignore')), force: true

# Configuration

generate_files 'config/initializers/config.rb', 'config/initializers/errbit.rb.example', 'config/initializers/secret_token.rb.example'
errbit = File.join(File.expand_path(File.dirname(__FILE__)), 'src/config/initializers/errbit.rb.example')
contents = File.read(errbit)
f = Tempfile.new('errbit')
f.write contents.gsub('%errbit_host%', CONFIG['errbit_host']).gsub('%errbit_port%', CONFIG['errbit_port']).gsub('%errbit_token%', CONFIG['errbit_token'])
f.close
file 'config/initializers/errbit.rb', File.read(f.path)
file 'config/initializers/secret_token.rb', File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src/config/initializers/secret_token.rb.example')), force: true

# Routes

generate_files 'config/routes.rb', 'lib/api_constraints.rb'
