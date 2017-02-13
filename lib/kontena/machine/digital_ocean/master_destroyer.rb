module Kontena
  module Machine
    module DigitalOcean
      class MasterDestroyer
        include Kontena::Cli::ShellSpinner

        attr_reader :client, :api_client

        # @param [String] token Digital Ocean token
        def initialize(token)
          @client = DropletKit::Client.new(access_token: token)
        end

        def run!(name)
          droplet = client.droplets.all.find{|d| d.name == name}
          if droplet
            spinner "Terminating DigitalOcean droplet #{name.colorize(:cyan)} " do
              result = client.droplets.delete(id: droplet.id)
              if result.is_a?(String)
                abort "Cannot delete droplet #{name.colorize(:cyan)} in DigitalOcean"
              end
            end
          else
            abort "Cannot find droplet #{name.colorize(:cyan)} in DigitalOcean"
          end
        end
      end
    end
  end
end
