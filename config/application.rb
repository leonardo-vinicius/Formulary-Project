require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Application
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.autoload_paths << "#{Rails.root}/lib"
    config.load_defaults 7.0

    # alteracoes 
    config.api_only = true
    config.time_zone = 'America/Sao_Paulo'
    # alteracoes

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
    # alteracoes banco de dados
    # config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

    # alteracoes autenticacao correta
    # config.middleware.use ActionDispatch::Cookies
    # config.middleware.use ActionDispatch::Session::CookieStore
    # config.middleware.use Rack::Deflater
    config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose: %w(access-token expiry token-type uid client),
          methods: %i(post get patch put delete)
          # expose: ['Authorization']
      end
    end
    # fim alteracoes autenticacao correta
  end
end
