require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

module Dexpense
  class Application < Rails::Application
    # Loading env variable from .env file
    Bundler.require(*Rails.groups)

    if ['development', 'test'].include? ENV['RAILS_ENV']
      Dotenv::Railtie.load
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.logger = Logger.new(STDOUT)

    config.hosts << 'bukukaskita-api.animapu.site'
    config.hosts << 'bukukaskita-api.shadow-animapu-1.site'
    config.hosts << 'bukukaskita-api.shadow-animapu-2.site'
  end
end
