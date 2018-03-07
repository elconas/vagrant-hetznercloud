require 'vagrant/util/retryable'
require 'vagrant-hetznercloud/util/timer'

module VagrantPlugins
  module Hetznercloud
    module Action
      # This creates the configured server.
      class CreateServer
        include Vagrant::Util::Retryable

        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_hetznercloud::action::create_server')
        end

        def call(env)
          # Initialize metrics if they haven't been
          env[:metrics] ||= {}

          config = env[:machine].provider_config

          server_type     = config.server_type
          image           = config.image
          name            = config.name
          ssh_keys        = config.ssh_keys

          env[:ui].info(I18n.t('vagrant_hetznercloud.creating_server'))
          env[:ui].info(" -- Type: #{server_type}")
          env[:ui].info(" -- Image: #{image}")
          env[:ui].info(" -- Name: #{name}")
          env[:ui].info(" -- SSH Keys: #{ssh_keys}")

          options = {
            name:            name,
            image:           image,
            server_type:     server_type,
            ssh_keys:        ssh_keys,
          }

          #options[:ssh_keys] = ssh_keys if ssh_keys
          #options[:security_group] = security_group if security_group

          begin
            server = env[:hetznercloud_compute].servers.create(options)
          rescue Fog::Hetznercloud::Compute::Error => e
            raise Errors::FogError, message: e.message
          rescue Excon::Errors::HTTPStatusError => e
            raise Errors::InternalFogError,
                  error: e.message,
                  response: e.response.body
          end

          env[:ui].info(" -- Server IP: #{server.public_ip_address}")

          @logger.info("Machine '#{name}' created.")

          # Immediately save the ID since it is created at this point.
          env[:machine].id = server.id

          # destroy the server if we were interrupted
          destroy(env) if env[:interrupted]

          @logger.info("Waiting for Machine '#{name}' with IP #{server.public_ip_address} to be ready.")
          server.wait_for { ready? }

          @app.call(env)
        end

        def recover(env)
          return if env['vagrant.error'].is_a?(Vagrant::Errors::VagrantError)

          destroy(env) if env[:machine].provider.state.id != :not_created
        end

        def destroy(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Action.action_destroy, destroy_env)
        end
      end
    end
  end
end
