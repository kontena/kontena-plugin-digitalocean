require_relative 'master/create_command'

class Kontena::Plugin::DigitalOcean::MasterCommand < Kontena::Command

  subcommand "create", "Create a new master to DigitalOcean", Kontena::Plugin::DigitalOcean::Master::CreateCommand

  def execute
  end
end
