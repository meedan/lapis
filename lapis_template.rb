# Usage: rails new <your application name> -m <path to this file>
# Reference: http://guides.rubyonrails.org/rails_application_templates.html

require 'tempfile'
require 'yaml'

# Helper functions

def generate_files(paths = [], force = true)
  paths.each do |path|
    method = (path =~ /\/$/).nil? ? 'file' : 'directory'
    path = path.gsub(/\/$/, '')
    puts "Generating #{path}..."
    source = File.join(File.expand_path(File.dirname(__FILE__)), 'src', path)
    if method == 'file'
      file path, File.read(source), force: force
    elsif method == 'directory'
      directory source, path, force: force
    end
  end
end

def generate_file_from_template(input, replacements = {}, output = nil)
  output ||= input
  template = File.join(File.expand_path(File.dirname(__FILE__)), 'src/' + input)
  contents = File.read(template)
  f = Tempfile.new('template')
  replacements.each do |placeholder, replacement|
    contents = contents.gsub(placeholder, replacement.nil? ? '' : replacement)
  end
  f.write contents
  f.close
  file output, File.read(f.path)
end

# Read configuration

CONFIG = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), 'config.yml'))

# Gems

gem 'sqlite3'
gem 'webmock'
gem 'mocha'
gem 'simplecov', require: false, group: :test
gem 'railroady'
gem 'airbrake', '4.3.3'
gem 'codeclimate-test-reporter', group: :test, require: nil
gem 'awesome_print', require: false, group: :development
gem 'gem-licenses'
gem 'logstasher'
gem 'auto_localize', '0.1'
gem 'thin'
gem 'protected_attributes'
gem 'swagger-docs', '0.1.9'
gem 'responders'
gem 'unicorn'

gsub_file 'Gemfile', "'debugger'", "'byebug'"

# Test structure

generate_files ['test/test_helper.rb', 'lib/sample_data.rb', 'test/controllers/base_api_controller_test.rb', 'test/integration/api_version_integration_test.rb', 'test/models/lapis_webhook_test.rb']

# API key

generate_files ['app/models/api_key.rb', 'test/models/api_key_test.rb', 'db/migrate/20150729232909_create_api_keys.rb', 'db/migrate/20160203234652_add_application_to_api_keys.rb']

# Documentation

generate_files ['doc/Makefile']

# Git

git :init

generate_file_from_template 'git/post-commit', { '%slack_webhook%' => CONFIG['slack_webhook'], '%slack_channel%' => CONFIG['slack_channel'], '%code_climate_token%' => CONFIG['code_climate_token'] }, '.git/hooks/post-commit'
file '.git/hooks/pre-commit', File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src/git/pre-commit'))
file '.gitignore', File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src/git/ignore')), force: true

# Configuration

generate_files ['config/initializers/config.rb', 'config/initializers/errbit.rb.example', 'config/initializers/secret_token.rb.example', 'config/config.yml.example', 'config/database.yml.example']

generate_file_from_template 'config/initializers/errbit.rb.example', { '%errbit_host%' => CONFIG['errbit_host'], '%errbit_port%' => CONFIG['errbit_port'], '%errbit_token%' => CONFIG['errbit_token'] }, 'config/initializers/errbit.rb'

file 'config/initializers/secret_token.rb', File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src/config/initializers/secret_token.rb.example')), force: true
file 'config/config.yml', File.read(File.join(File.expand_path(File.dirname(__FILE__)), 'src/config/config.yml.example')), force: true

environment 'config.generators do |g|
               g.javascripts false
               g.stylesheets false
               g.template_engine false
               g.helper false
               g.assets false
             end'

initializer 'info.rb', <<-CODE
  INFO = {
    title: '#{CONFIG['title']}',
    description: '#{CONFIG['description']}',
    author: '#{CONFIG['author']}',
    author_email: '#{CONFIG['author_email']}'
  }
CODE

# Routes

force = ENV['LOCATION'].blank? ? true : false
generate_files ['config/routes.rb'], force
generate_files ['lib/api_constraints.rb']

# Lib

generate_files ['lib/error_codes.rb']

# Rake tasks

generate_files ['lib/tasks/coverage.rake', 'lib/tasks/create_api_key.rake', 'lib/tasks/error_codes.rake', 'lib/tasks/licenses.rake', 'lib/tasks/seed.rake', 'lib/tasks/client_gem.rake', 'lib/tasks/client_php.rake', 'lib/tasks/clients/php/LapisClient.php', 'lib/tasks/clients/php/LapisClientTest.php']

# Controllers

generate_files ['app/controllers/api/v1/base_api_controller.rb'], false
generate_files ['app/controllers/application_controller.rb']

# Swagger

generate_files ['public/api/', 'config/initializers/swagger.rb']

# Code Climate

generate_files ['.codeclimate.yml']

# Webhook

generate_files ['lib/lapis_webhook.rb']

# Public

generate_files ['public/index.html']

# Docker

generate_file_from_template 'docker/Dockerfile', { '%author%' => CONFIG['author'], '%author_email%' => CONFIG['author_email'] }
generate_file_from_template 'docker/run.sh', { '%app_name%' => app_name }
generate_file_from_template 'docker/shell.sh', { '%app_name%' => app_name }
generate_files ['docker/nginx.conf', 'docker/Procfile']
run 'chmod +x docker/*.sh 2>/dev/null'

# License

generate_file_from_template 'LICENSE.txt', { '%YEAR%' => Time.now.year.to_s, '%NAME%' => CONFIG['author'] }

# After bundle

after_bundle do
  rake 'db:migrate'
  rake 'db:migrate', env: 'test'
  run 'rm -rf app/assets && mkdir tmp 2>/dev/null'
  run 'touch tmp/.gitkeep'
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
  git branch: 'develop'
  git checkout: 'develop'
  run 'chmod +x .git/hooks/post-commit'
  run 'chmod +x .git/hooks/pre-commit'
  run 'chmod +x docker/*.sh'
  run '.git/hooks/pre-commit'
  rake 'test:coverage'
  git add: 'public/coverage'
  git commit: %Q{ -m 'Code coverage' }
  run 'spring stop > /dev/null'
end
