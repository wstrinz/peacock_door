require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PeacockDoor
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.to_prepare do
      DeviseController.respond_to :html, :json
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:8080', '192.168.99.1:8100'
        resource '/users', headers: :any, methods: [:get, :post, :options], credentials: true
        resource '/users/*', headers: :any, methods: [:get, :post, :options], credentials: true
        resource '/', headers: :any, methods: [:get, :post, :options], credentials: true
      end
    end
  end
end
