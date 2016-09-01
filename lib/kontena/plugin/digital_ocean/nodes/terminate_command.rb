module Kontena::Plugin::DigitalOcean::Nodes
  class TerminateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions

    parameter "NAME", "Node name"
    option "--token", "TOKEN", "DigitalOcean API token", required: true

    def execute
      require_api_url
      require_current_grid

      require_relative '../../../machine/digital_ocean'
      grid = client(require_token).get("grids/#{current_grid}")
      destroyer = destroyer(client(require_token), token)
      destroyer.run!(grid, name)
    end

    # @param [Kontena::Client] client
    # @param [String] token
    def destroyer(client, token)
      Kontena::Machine::DigitalOcean::NodeDestroyer.new(client, token)
    end
  end
end
