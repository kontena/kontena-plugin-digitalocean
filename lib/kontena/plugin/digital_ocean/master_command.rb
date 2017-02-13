require_relative 'master/create_command'
require_relative 'master/terminate_command'

class Kontena::Plugin::DigitalOcean::MasterCommand < Kontena::Command

  subcommand "create", "Create a new master to DigitalOcean", Kontena::Plugin::DigitalOcean::Master::CreateCommand
  subcommand "terminate", "Terminate DigitalOcean master", Kontena::Plugin::DigitalOcean::Master::TerminateCommand

  def execute
  end
end
