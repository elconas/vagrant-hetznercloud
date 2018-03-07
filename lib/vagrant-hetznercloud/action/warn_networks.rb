module VagrantPlugins
  module Hetznercloud
    module Action
      class WarnNetworks
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          if env[:machine].config.vm.networks.length > 1
            env[:ui].warn(I18n.t('vagrant_hetznercloud.warn_networks'))
          end

          @app.call(env)
        end
      end
    end
  end
end
