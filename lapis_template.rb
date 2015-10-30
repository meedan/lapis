# Usage: rails new <your application name> -m <path to this file>
# Reference: http://guides.rubyonrails.org/rails_application_templates.html

require 'tempfile'
require 'yaml'

# Helper function

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

# Read configuration

CONFIG = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), 'config.yml'))

# Gems

gem 'sqlite3'
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
gem 'swagger-docs'
gem 'responders'

# Test structure

generate_files ['test/test_helper.rb', 'lib/sample_data.rb', 'test/controllers/base_api_controller_test.rb', 'test/integration/api_version_integration_test.rb']

# API key

generate_files ['app/models/api_key.rb', 'test/models/api_key_test.rb', 'db/migrate/20150729232909_create_api_keys.rb']

# Documentation

generate_files ['doc/Makefile']

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

generate_files ['config/initializers/config.rb', 'config/initializers/errbit.rb.example', 'config/initializers/secret_token.rb.example', 'config/config.yml.example', 'config/database.yml.example']
errbit = File.join(File.expand_path(File.dirname(__FILE__)), 'src/config/initializers/errbit.rb.example')
contents = File.read(errbit)
f = Tempfile.new('errbit')
f.write contents.gsub('%errbit_host%', CONFIG['errbit_host']).gsub('%errbit_port%', CONFIG['errbit_port']).gsub('%errbit_token%', CONFIG['errbit_token'])
f.close
file 'config/initializers/errbit.rb', File.read(f.path)
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

generate_files ['config/routes.rb'], false
generate_files ['lib/api_constraints.rb']

# Lib

generate_files ['lib/error_codes.rb']

# Rake tasks

generate_files ['lib/tasks/coverage.rake', 'lib/tasks/create_api_key.rake', 'lib/tasks/error_codes.rake', 'lib/tasks/licenses.rake', 'lib/tasks/seed.rake', 'lib/tasks/client_gem.rake']

# Controllers

generate_files ['app/controllers/api/v1/base_api_controller.rb'], false
generate_files ['app/controllers/application_controller.rb']

# Swagger

generate_files ['public/api/', 'config/initializers/swagger.rb']

# Code Climate

generate_files ['.codeclimate.yml']

# Webhook

generate_files ['lib/lapis_webhook.rb']

rake 'db:migrate'
rake 'db:migrate', env: 'test'

# Public

generate_files ['public/index.html']

# License

license = File.join(File.expand_path(File.dirname(__FILE__)), 'src/LICENSE.txt')
contents = File.read(license)
f = Tempfile.new('license')
f.write contents.gsub('%YEAR%', Time.now.year.to_s).gsub('%NAME%', CONFIG['author'])
f.close
file 'LICENSE.txt', File.read(f.path)

after_bundle do
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
  git branch: 'develop'
  git checkout: 'develop'
  run 'chmod +x .git/hooks/post-commit'
  run 'chmod +x .git/hooks/pre-commit'
  run '.git/hooks/pre-commit'
  rake 'test:coverage'
  git add: 'public/coverage'
  git commit: %Q{ -m 'Code coverage' }
  run 'spring stop'
end
