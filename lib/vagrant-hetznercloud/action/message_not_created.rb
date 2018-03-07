module VagrantPlugins
  module Hetznercloud
    module Action
      class MessageNotCreated
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_hetznercloud.not_created'))
          @app.call(env)
        end
      end
    end
  end
end
