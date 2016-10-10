require_relative '../prompts'

module Kontena::Plugin::DigitalOcean::Nodes
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Plugin::DigitalOcean::Prompts

    parameter "[NAME]", "Node name"
    option "--token", "TOKEN", "DigitalOcean API token"
    option "--region", "REGION", "Region"
    option "--ssh-key", "SSH_KEY", "Path to ssh public key", default: '~/.ssh/id_rsa.pub'
    option "--size", "SIZE", "Droplet size", default: '1gb'
    option "--count", "COUNT", "How many droplets to create", default: 1
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'

    def execute
      require_api_url
      require_current_grid

      do_token = ask_do_token

      require_relative '../../../machine/digital_ocean'

      do_region = ask_droplet_region(do_token)
      do_size = ask_droplet_size(do_token, do_region)

      grid = fetch_grid
      provisioner = provisioner(client(require_token), do_token)
      provisioner.run!(
        master_uri: api_url,
        grid_token: grid['token'],
        grid: current_grid,
        ssh_key: ssh_key,
        name: name,
        size: do_size,
        count: count,
        region: do_region,
        version: version
      )
    end

    # @param [Kontena::Client] client
    # @param [String] token
    def provisioner(client, token)
      Kontena::Machine::DigitalOcean::NodeProvisioner.new(client, token)
    end

    # @return [Hash]
    def fetch_grid
      client(require_token).get("grids/#{current_grid}")
    end
  end
end
