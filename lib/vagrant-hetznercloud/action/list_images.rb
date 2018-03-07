module VagrantPlugins
  module Hetznercloud
    module Action
      class ListImages
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          compute = env[:hetznercloud_compute]

          env[:ui].info(format('%-37s %-26s %-7s %-36s %s', 'Image ID', 'Created At', 'Type', 'Description', 'Image Name'), prefix: false)
          compute.images.sort_by(&:name).each do |image|
            created_at = Time.parse(image.created)
            env[:ui].info(format('%-37s %-26s %-7s %-36s %s', image.identity, created_at, image.type, image.description, image.name), prefix: false)
          end

          @app.call(env)
        end
      end
    end
  end
end
