module VagrantPlugins
  module Hetznercloud
    module Errors
      class VagrantHetznercloudError < Vagrant::Errors::VagrantError
        error_namespace('vagrant_hetznercloud.errors')
      end

      class FogError < VagrantHetznercloudError
        error_key(:fog_error)
      end

      class InternalFogError < VagrantHetznercloudError
        error_key(:internal_fog_error)
      end

      class ServerReadyTimeout < VagrantHetznercloudError
        error_key(:server_ready_timeout)
      end
    end
  end
end
