require 'fog/hetznercloud'

module VagrantPlugins
  module Hetznercloud
    module Action
      # This action connects to Hetznercloud, verifies credentials work, and
      # puts the Hetznercloud connection object into the `:hetznercloud_compute` key
      # in the environment.
      class ConnectHetznercloud
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_hetznercloud::action::connect_hetznercloud')
        end

        def call(env)
          # Get the configs
          provider_config = env[:machine].provider_config

          # Build the fog config
          fog_config = {
            provider:                  :hetznercloud,
            hetznercloud_token:        provider_config.token
          }

          @logger.info('Connecting to Hetznercloud...')
          env[:hetznercloud_compute] = Fog::Compute.new(fog_config)

          @app.call(env)
        end
      end
    end
  end
end
