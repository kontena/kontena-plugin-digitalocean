module Kontena::Plugin::DigitalOcean::Nodes
  class TerminateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions

    parameter "NAME", "Node name"
    option "--token", "TOKEN", "DigitalOcean API token"
    option "--force", :flag, "Force remove", default: false, attribute_name: :forced

    def execute
      require_api_url
      require_current_grid
      confirm_command(name) unless forced?

      if self.token.nil?
        do_token = prompt.ask('DigitalOcean API token: ')
      else
        do_token = self.token
      end

      require_relative '../../../machine/digital_ocean'
      grid = client(require_token).get("grids/#{current_grid}")
      destroyer = destroyer(client(require_token), do_token)
      destroyer.run!(grid, name)
    end

    # @param [Kontena::Client] client
    # @param [String] token
    def destroyer(client, token)
      Kontena::Machine::DigitalOcean::NodeDestroyer.new(client, token)
    end
  end
end
