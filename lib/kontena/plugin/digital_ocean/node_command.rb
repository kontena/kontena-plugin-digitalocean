class Kontena::Plugin::DigitalOcean::NodeCommand < Kontena::Command
  subcommand "create", "Create a new node to DigitalOcean", load_subcommand('kontena/plugin/digital_ocean/nodes/create_command')
  subcommand "restart", "Restart DigitalOcean node", load_subcommand('kontena/plugin/digital_ocean/nodes/restart_command')
  subcommand "terminate", "Terminate DigitalOcean node", load_subcommand('kontena/plugins/digital_ocean/nodes/terminate_command')
end
