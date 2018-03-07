module VagrantPlugins
  module Hetznercloud
    module Command
      class Images < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant hetznercloud images [options]'
          end

          argv = parse_options(opts)
          return unless argv

          with_target_vms(argv, provider: :hetznercloud) do |machine|
            machine.action('list_images')
          end
        end
      end
    end
  end
end
