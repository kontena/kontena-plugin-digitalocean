require_relative 'digital_ocean/master_command'
require_relative 'digital_ocean/node_command'

class Kontena::Plugin::DigitalOceanCommand < Kontena::Command

  subcommand 'master', 'DigitalOcean master related commands', Kontena::Plugin::DigitalOcean::MasterCommand
  subcommand 'node', 'DigitalOcean node related commands', Kontena::Plugin::DigitalOcean::NodeCommand

  def execute
  end
end
