module VagrantPlugins
  module Hetznercloud
    module Action
      # This stops the running server.
      class StopServer
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          server = env[:hetznercloud_compute].servers.get(env[:machine].id)

          if env[:machine].state.id == :stopped
            env[:ui].info(I18n.t('vagrant_hetznercloud.already_status', status: env[:machine].state.id))
          else
            env[:ui].info(I18n.t('vagrant_hetznercloud.stopping'))
            server.poweroff(async: false)
          end

          @app.call(env)
        end
      end
    end
  end
end
