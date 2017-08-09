class Kontena::Plugin::DigitalOcean::MasterCommand < Kontena::Command
  subcommand "create", "Create a new master to DigitalOcean", load_subcommand('kontena/plugin/digital_ocean/master/create_command')
  subcommand "terminate", "Terminate DigitalOcean master", load_subcommand('kontena/plugin/digital_ocean/master/terminate_command')
end
