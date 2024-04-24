# Example: Ruby on Rails app with FusionAuth Custom Scopes

This repository contains a Ruby on Rails app that works with a locally running instance of [FusionAuth](https://fusionauth.io/), the authentication and authorization platform.

## Setup

### Prerequisites
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/): This will be needed for pulling down the various dependencies.
- [Rails](https://guides.rubyonrails.org/getting_started.html): This will be used in order to run the Rails server.
- [Docker](https://www.docker.com): The quickest way to stand up FusionAuth.
  - You wil need FusionAuth 1.50.0 or greater.
  - (Alternatively, you can [Install FusionAuth Manually](https://fusionauth.io/docs/v1/tech/installation-guide/)).

This app has been tested with Ruby 3.2.2 and Rails 7.0.4.3

### FusionAuth Installation via Docker

The root of this project directory (next to this README) are two files [a Docker compose file](./docker-compose.yml) and an [environment variables configuration file](./.env). Assuming you have Docker installed on your machine, you can stand up FusionAuth up on your machine with:

```
docker compose up -d
```

The FusionAuth configuration files also make use of a unique feature of FusionAuth, called [Kickstart](https://fusionauth.io/docs/v1/tech/installation-guide/kickstart): when FusionAuth comes up for the first time, it will look at the [Kickstart file](./kickstart/kickstart.json) and mimic API calls to configure FusionAuth for use when it is first run. 

> **NOTE**: If you ever want to reset the FusionAuth system, delete the volumes created by docker compose by executing `docker compose down -v`. 

FusionAuth will be initially configured with two applications.  The first will be the Example App with these settings:

* Your client Id is: `e9fdb985-9173-4e01-9d73-ac2d60d1dc8e`
* Your client secret is: `super-secret-secret-that-should-be-regenerated-for-production`
* Your admin username is `admin@example.com` and your password is `password`.
* Your teller username is `teller@example.com` and your password is `password`.
* Your customer username is `customer@example.com` and your password is `password`.
* Your fusionAuthBaseUrl is `http://localhost:9011/`


The second application will be the Budget Buddy application with the following settings:
* Your client Id is: `e9fdb985-9173-4e01-9d73-ac2d60d1dc8e`
* Your client secret is: `super-secret-secret-that-should-be-regenerated-for-production`

The Budget Buddy application is configured as a Third-party application. This means the application is external to the authorization server. Users will be prompted to consent to requested OAuth scopes.

### Update and Start the FusionAuth Quickstart Ruby on Rails Change Bank API

You will need to clone the FusionAuth Ruby on Rails API Quickstart at [https://github.com/FusionAuth/fusionauth-quickstart-ruby-on-rails-api](https://github.com/FusionAuth/fusionauth-quickstart-ruby-on-rails-api)

Do not run the `docker copose up -d` from the instructions in api application. 

Update the following files in the API Quickstart with the values from the files in this repository directory `fusionauth-quickstart-ruby-on-rails-api-modifications`.

| Copy | To |
| :----------------------------------------------------------------------------- |:------------------------------------ |
| fusionauth-example-ruby-on-rails-custom-scopes/fusionauth-quickstart-ruby-on-rails-api-modification/.env.development | fusionauth-quickstart-ruby-on-rails-api/complete-application/.env.development |
| fusionauth-example-ruby-on-rails-custom-scopes/fusionauth-quickstart-ruby-on-rails-api-modification/app/controllers/get_balance_controller.rb | fusionauth-quickstart-ruby-on-rails-api/complete-application/app/controllers/get_balance_controller.rb |
| fusionauth-example-ruby-on-rails-custom-scopes/fusionauth-quickstart-ruby-on-rails-api-modification/config/routes.rb | fusionauth-quickstart-ruby-on-rails-api/complete-application/config/routes.rb |
| fusionauth-example-ruby-on-rails-custom-scopes/fusionauth-quickstart-ruby-on-rails-api-modification/config/initializers/jwt_rack.rb | fusionauth-quickstart-ruby-on-rails-api/complete-application/config/initializers/jwt_rack.rb |

These changes will provide the Change Bank API with the Budget Buddy application settings and create a new endpoint for the api named `get_balance`.

From a terminal window in the `fusionauth-quickstart-ruby-on-rails-api/complete-application` directory, install the dependencies and run via the Gemfile.
```
cd complete-application
bundle install
bundle e rails s -p 4001
```

### Budget Buddy Ruby on Rails complete-app

The `complete-app` directory for this repository contains a minimal Ruby on Rails app called Budget Buddy. This is a simple app and contains no real functionality. The basic login will accept any email that is not blank. This is simply to convey the idea of login into any system that is not the Change Bank application on the FusionAuth host.

From a new terminal window in the `fusionauth-example-ruby-on-rails-custom-scopes/complete-application` directory, install the dependencies and run via the Gemfile.
```
cd complete-app
bundle install
OP_SECRET_KEY=super-secret-secret-that-should-be-regenerated-for-production bundle exec rails s
```

Now vist the Rails app at [http://localhost:3000](http://localhost:3000)
You can login with any email and password.

Click on the `Get Balance` tab. Click the `Connect` buttion and login to Change Bank using:
* email: customer@example.com
* password: password

Next, click `Allow` to allow Budget Budy to read your Change Bank balance.

You will now see a balance that is read from the Change Bank API.

### Further Information

Visit https://fusionauth.io/quickstarts/quickstart-ruby-rails-web for a step by step guide on how to build this Rails app integrated with FusionAuth by scratch.

### Troubleshooting

* I get `This site can’t be reached localhost refused to connect.` when I click the Login button

Ensure FusionAuth is running in the Docker container.  You should be able to login as the admin user, `admin@example.com` with the password of `password` at http://localhost:9011/admin

* I get an error page when I click on the Login button with message of `"error_reason" : "invalid_client_id"`

Ensure the value for `config.x.fusionauth.client_id` in the file `config/environments/development.rb` matches client id configured in FusionAuth for the Example App application at http://localhost:9011/admin/application/

* I'm getting an error from Rails after logging in

```
Rack::OAuth2::Client::Error
invalid_client :: Invalid client authentication credentials.
```

This indicates that Omniauth is unable to call FusionAuth to validate the returned token.  It is likely caused not supplying the correct *client secret*.  Ensure the `OP_SECRET_KEY` used to start rails matches the FusionAuth ExampleApp client secret.  http://localhost:9011/admin/application/
