## API Base

This a [Ruby On Rails template](http://guides.rubyonrails.org/rails_application_templates.html) to be shared across Meedan's APIs.

Currently based on Ruby 2.0 and Rails 4.0.

You can also use this README as a model for your README.

### Features

* Documentation: licenses, API endpoints, Swagger, diagrams (models and controllers)
* Tests: Basic testing framework that notifies Slack
* Authentication: webhooks and tokens
* Integrations: Code Climate (code quality and coverage) and Errbit (exception handling)
* API: Versioning and output control

### How to use this template

* Define settings in `config.yml`
* Generate your application `rails new <application name> -m <path to this file>`
* For each model: create a method that creates an instance of this class at `lib/sample_data.rb`
* Your controllers should inherit from `BaseApiController`... generate them by running `rails g controller Api::V1::<ControllerName>`
* By default, all controller actions require a valid token... you can `skip_before_filter :authenticate_from_token!` in order to avoid that
* Document your API on files at `app/controllers/concerns/<controller name>_doc.rb`
* Generate the documentation: `cd doc && make`

### Example

Check [this example of an API built on top of this framework](https://github.com/meedan/api-base-example/).
