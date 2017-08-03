require_relative '../prompts'

module Kontena::Plugin::DigitalOcean::Nodes
  class RestartCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Plugin::DigitalOcean::Prompts

    parameter "[NAME]", "Node name"
    option "--token", "TOKEN", "DigitalOcean API token", environment_variable: "DO_TOKEN"

    def execute
      suppress_warnings # until DO merges resource_kit pr #32
      require_api_url
      require_current_grid
      do_token = ask_do_token

      require_relative '../../../machine/digital_ocean'

      node_name = ask_node(require_token)
      client = DropletKit::Client.new(access_token: do_token)
      droplet = client.droplets.all.find{|d| d.name == node_name}
      if droplet
        spinner "Restarting DigitalOcean droplet #{pastel.cyan(name)} " do
          client.droplet_actions.reboot(droplet_id: droplet.id)
          sleep 1 until client.droplets.find(id: droplet.id).status == 'active'
        end
      else
        exit_with_error "Cannot find droplet #{pastel.cyan(name)} in DigitalOcean"
      end
    ensure
      resume_warnings
    end
  end
end
