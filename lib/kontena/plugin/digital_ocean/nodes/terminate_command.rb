require_relative '../prompts'

module Kontena::Plugin::DigitalOcean::Nodes
  class TerminateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Plugin::DigitalOcean::Prompts

    parameter "[NAME]", "Node name"
    option "--token", "TOKEN", "DigitalOcean API token", environment_variable: "DO_TOKEN"
    option "--force", :flag, "Force remove", default: false, attribute_name: :forced

    def execute
      suppress_warnings # until DO merges resource_kit pr #32
      require_api_url
      require_current_grid
      token = require_token
      node_name = ask_node(token)
      do_token = ask_do_token
      confirm_command(node_name) unless forced?

      require_relative '../../../machine/digital_ocean'
      grid = client(require_token).get("grids/#{current_grid}")
      destroyer = destroyer(client(token), do_token)
      destroyer.run!(grid, node_name)
    ensure
      resume_warnings
    end

    # @param [Kontena::Client] client
    # @param [String] token
    def destroyer(client, token)
      Kontena::Machine::DigitalOcean::NodeDestroyer.new(client, token)
    end
  end
end
