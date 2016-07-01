module Kontena::Plugin::DigitalOcean::Nodes
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions

    parameter "[NAME]", "Node name"
    option "--token", "TOKEN", "DigitalOcean API token", required: true
    option "--ssh-key", "SSH_KEY", "Path to ssh public key", default: '~/.ssh/id_rsa.pub'
    option "--size", "SIZE", "Droplet size", default: '1gb'
    option "--region", "REGION", "Region", default: 'ams2'
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'

    def execute
      require_api_url
      require_current_grid

      require 'kontena/machine/digital_ocean'
      grid = fetch_grid
      provisioner = provisioner(client(require_token), token)
      provisioner.run!(
        master_uri: api_url,
        grid_token: grid['token'],
        grid: current_grid,
        ssh_key: ssh_key,
        name: name,
        size: size,
        region: region,
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
