module Kontena
  module Machine
    module DigitalOcean
      class SshKeyManager

        attr_reader :client

        # @param [String] token Digital Ocean API token
        def initialize(token)
          @client = DropletKit::Client.new(access_token: token)
        end

        def find_by_public_key(public_key)
          list.find { |key| key.public_key == public_key }
        end

        def list
          client.ssh_keys.all.to_a
        end

        def create(public_key)
          client.ssh_keys.create(DropletKit::SSHKey.new(public_key: public_key, name: public_key.split(/\s+/).last))
        end

        def find_or_create_by_public_key(public_key)
          find_by_public_key(public_key) || create(public_key)
        end
      end
    end
  end
end
