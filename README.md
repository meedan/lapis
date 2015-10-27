## Lapis

Lapis is a [Ruby On Rails template](http://guides.rubyonrails.org/rails_application_templates.html) to generate APIs that implement some [good practices](#) that [Meedan](http://meedan.com) follows.

Currently based on Ruby 2.0 and Rails 4.

### Features

* Documentation: licenses, API endpoints, Swagger, diagrams (models and controllers)
* Tests: Basic testing framework that notifies Slack
* Authentication: webhooks and tokens
* Integrations: Code Climate (code quality and coverage) and Errbit (exception handling)
* API: Versioning and output control

### How to use this template

* Define settings in `config.yml`
* Generate your application `rails new <application name> -m <path to lapis_template.rb>`
* For each model: create a method that creates an instance of this class at `lib/sample_data.rb`
* Your controllers should inherit from `BaseApiController`... generate them by running `rails g controller Api::V1::<ControllerName>`
* By default, all controller actions require a valid token... you can `skip_before_filter :authenticate_from_token!` in order to avoid that
* Document your API on files at `app/controllers/concerns/<controller name>_doc.rb` (remember to `include YourControllerDoc` in your controller)
* Add your routes to `config/routes.rb`
* You can apply this template to an existing application by running `rake rails:template LOCATION=<path to lapis_template.rb>`
* Generate the documentation: `cd doc && make`
* Generate a Ruby gem that wraps this API to be used and tested by clients, by running: `rake lapis:build_client_gem`

### Example

Check [this example of an API built on top of this framework](https://github.com/meedan/lapis-example/).

### TODO

* Add a rake task that generates a Dockerfile
