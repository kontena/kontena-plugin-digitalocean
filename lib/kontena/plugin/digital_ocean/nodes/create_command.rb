require 'kontena/plugin/digital_ocean/prompts'

module Kontena::Plugin::DigitalOcean::Nodes
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Plugin::DigitalOcean::Prompts

    parameter "[NAME]", "Node name"
    option "--token", "TOKEN", "DigitalOcean API token", environment_variable: 'DO_TOKEN'
    option "--region", "REGION", "Region"
    option "--ssh-key", "SSH_KEY", "Path to ssh public key"
    option "--size", "SIZE", "Droplet size"
    option "--count", "COUNT", "How many droplets to create"
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'
    option "--channel", "CHANNEL", "Define CoreOS image channel"

    def execute
      suppress_warnings # until DO merges resource_kit pr #32
      require 'kontena/machine/digital_ocean'
      require_api_url
      require_current_grid

      do_token = ask_do_token
      do_region = ask_droplet_region(do_token)
      coreos_channel = self.channel || ask_channel
      do_size = ask_droplet_size(do_token, do_region)
      do_count = ask_droplet_count
      do_ssh_key_id = ask_ssh_key(do_token)

      grid = fetch_grid
      provisioner = provisioner(client(require_token), do_token)
      provisioner.run!(
        master_uri: api_url,
        grid_token: grid['token'],
        grid: current_grid,
        ssh_key_id: do_ssh_key_id,
        name: name,
        size: do_size,
        count: do_count,
        region: do_region,
        version: version,
        channel: coreos_channel
      )
    ensure
      resume_warnings
    end

    def ask_droplet_count
      if self.count.nil?
        prompt.ask('How many droplets?:', default: 1)
      else
        self.count
      end
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
