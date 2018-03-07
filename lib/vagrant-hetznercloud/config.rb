require 'toml'

module VagrantPlugins
  module Hetznercloud
    class Config < Vagrant.plugin('2', :config)
      # The bootscript ID. If nil, the default bootscript for the image will be
      # used.
      #
      # @return [String]
      attr_accessor :user_data

      # The type of the server to launch, such as 'C1'. Defaults to 'C2S'.
      #
      # @return [String]
      attr_accessor :server_type

      # The image ID or name.
      #
      # @return [String]
      attr_accessor :image

      # The name of the server.
      #
      # @return [String]
      attr_accessor :name

      # The name of the Hetznercloud location to create the server in. It can also be
      # configured with SCW_REGION environment variable. Defaults to par1.
      #
      # @return [String]
      attr_accessor :location

      # The security group ID to associate with the server. If nil,
      # organization's default security group will be used.
      #
      # @return [String]
      attr_accessor :datacenter

      # The interval to wait for checking a server's state. Defaults to 2
      # seconds.
      #
      # @return [Fixnum]
      attr_accessor :server_check_interval

      # The timeout to wait for a server to become ready. Defaults to 120
      # seconds.
      #
      # @return [Fixnum]
      attr_accessor :server_ready_timeout

      # Specifies which address to connect to with ssh.
      # Must be one of:
      #  - :public_ip_address
      # This attribute also accepts an array of symbols.
      #
      # @return [Symbol]
      attr_accessor :ssh_host_attribute

      # The API token to access Hetznercloud. It can also be configured with
      # HETZNERCLOUD_TOKEN environment variable.
      #
      # @return [String]
      attr_accessor :token

      # ssh keys
      #
      # @return [Array]
      attr_accessor :ssh_keys

      # active context in the hcloud config file
      #
      # @return [String]
      attr_accessor :active_context

      def initialize
        @user_data             = UNSET_VALUE
        @server_type           = UNSET_VALUE
        @image                 = UNSET_VALUE
        @name                  = UNSET_VALUE
        @location              = UNSET_VALUE
        @datacenter            = UNSET_VALUE
        @server_check_interval = UNSET_VALUE
        @server_ready_timeout  = UNSET_VALUE
        @ssh_host_attribute    = UNSET_VALUE
        @token                 = UNSET_VALUE
        @ssh_keys              = UNSET_VALUE
        @active_context        = UNSET_VALUE
      end

      def finalize!
        @user_data       = nil if @user_data == UNSET_VALUE
        @server_type     = 'cx11' if @server_type == UNSET_VALUE
        @image           = 'centos-7' if @image == UNSET_VALUE

        if @name == UNSET_VALUE
          require 'securerandom'
          @name = "h-#{SecureRandom.hex(3)}"
        end

        @region                = (ENV['HETZNERCLOUD_REGION']) if @region == UNSET_VALUE
        @datacenter            = (ENV['HETZNERCLOUD_DATACENTER']) if @datacenter == UNSET_VALUE
        @server_check_interval = 2 if @server_check_interval == UNSET_VALUE
        @server_ready_timeout  = 120 if @server_ready_timeout == UNSET_VALUE
        @ssh_host_attribute    = nil if @ssh_host_attribute == UNSET_VALUE
        @active_context        = nil if @active_context == UNSET_VALUE
        @token                 = (ENV['HETZNERCLOUD_TOKEN'] || get_token(@active_context)) if @token == UNSET_VALUE
        @ssh_keys              = [] if @ssh_keys == UNSET_VALUE
      end

      def validate(_machine)
        errors = _detected_errors

        errors << I18n.t('vagrant_hetznercloud.config.token_required') if @token.nil?
        errors << I18n.t('vagrant_hetznercloud.config.ssh_keys_required') if @token.nil?

        { 'Hetznercloud Provider' => errors }
      end

      # Get the token from the hckoud cli config file (if it exists)
      def get_token(active_context = nil)

              # The config file
              config_file = ENV['HOME'] + "/.config/hcloud/cli.toml"
              return nil unless File.exists?(config_file)

              # Load the file
              config_data = TOML.load_file(config_file)

              # default context if not specified
              active_context = config_data["active_context"] if active_context.nil?

              context = config_data["contexts"].find { |context|
                      context["name"] == active_context
              }

              # Not found
              return nil if context.nil?
              return nil unless context.has_key?('token')
              return context["token"]
      end

    end
  end
end
