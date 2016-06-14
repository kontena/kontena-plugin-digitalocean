require_relative 'nodes/create_command'
require_relative 'nodes/restart_command'
require_relative 'nodes/terminate_command'

class Kontena::Plugin::DigitalOcean::NodeCommand < Kontena::Command

  subcommand "create", "Create a new node to DigitalOcean", Kontena::Plugin::DigitalOcean::Nodes::CreateCommand
  subcommand "restart", "Restart DigitalOcean node", Kontena::Plugin::DigitalOcean::Nodes::RestartCommand
  subcommand "terminate", "Terminate DigitalOcean node", Kontena::Plugin::DigitalOcean::Nodes::TerminateCommand

  def execute
  end
end
