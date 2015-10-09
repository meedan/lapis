## API Base

This a [Ruby On Rails template](http://guides.rubyonrails.org/rails_application_templates.html) to be shared across Meedan's APIs.

Currently based on Ruby 2.0 and Rails 4.0.

You can also use this README as a model for your README.

[![Code Climate](https://codeclimate.com/repos/541c5cf269568014f20085ed/badges/13412e8119cd6b0ef6e4/gpa.png)](https://codeclimate.com/repos/541c5cf269568014f20085ed/feed)
[![Test Coverage](https://codeclimate.com/repos/541c5cf269568014f20085ed/badges/13412e8119cd6b0ef6e4/coverage.png)](https://codeclimate.com/repos/541c5cf269568014f20085ed/feed)

### How to run the system

* Ensure you have Ruby 2.0
* Get this code and go to its root
* Run `bundle install` to install the dependencies
* Copy config/database.yml.example to config/database.yml and configure your database
* Copy config/config.yml.example to config/config.yml and configure the other options
* Copy config/initializers/secret\_token.rb.example to config/initializers/secret\_token.rb
* Run `rake db:migrate` to create the database (check config/database.yml first)
* Run `rake db:seed` to create some initial data
* Start the server with `rails s` (defaults to Thin web server on development mode)

### Documentation

Documentation is located under "doc/" and can be updated by running `cd doc/ && make clean && make`.

### Exceptions Handling

This application uses Errbit to handle exceptions. You can set it up by copying config/initializers/errbit.rb.example to
config/initializers/errbit.rb and setting the credentials. Then just restart the server.

### Tests

We have automated tests for the API. You can run them by invoking `rake` or `rake test`.
In order to calculate coverage, you can run as `rake test:coverage`.

### Code Coverage

Code coverage is powered by Simplecov. You can check the current code coverage by accessing
http://localhost:3000/coverage/index.html. You can update it by running `rake test:coverage` , which will run the
test suite but also check code coverage. Then access the same address and check the results.

### Using the API

The examples here use cURL, but you can use anything. If you access the application on the browser, you will be able to use a simple HTML+JS UI to interact with the API. You can also check all available calls by running `rake routes`.
To make it simple, the authentication headers were omitted from the examples below, but there is a section about
authentication at the end. You can test the whole API after running `rake db:seed:sample` by running `./scripts/test-api-calls.sh`.

#### Authentication

Users can authenticate using external services (like Facebook or Twitter) by providing the source name, user id, user token and secret (optional) as request headers: X-Meedan-Provider, X-Meedan-Uuid, X-Meedan-Token and X-Meedan-Secret

The first request should create a user in the database.

Clients can also authenticate by providing an API key.

#### Versioning

You can decide which version to use by setting an accept header, like this: "Accept: application/vnd.meedan.v1". For the time being, we have just version 1, which is default, so you don't need to set it. The accept header is also returned with the responses.

#### Failures

In case of failure, all calls return a JSON object like this:

`{"type":"error","data":{"message":"Parameters missing","code":0}}`

The error code is always a number. You can check the available error codes by running `rake meedan:error_codes`.

#### Delayed Job

Background jobs are processed by Delayed::Job. You can manage it through the UI at /delayed_job. You can define the user and password
on config/config.yml.

#### Coding Conventions

* No tabs
* 2 spaces

On Vim: `:set expandtab` and `:set tabstop=2`

#### Things to fix

Run `./scripts/fixme.sh` to list all fixme's that are on code.

#### How to use this template

* Define settings in `config.yml`
* Generate your application `rails new <application name> -m <path to this file>`
* For each model: create a method that creates an instance of this class at `lib/sample_data.rb`
