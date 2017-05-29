require 'kontena_cli'
require 'kontena/plugin/digital_ocean'
require 'kontena/cli/subcommand_loader'

Kontena::MainCommand.register("digitalocean", "DigitalOcean specific commands", Kontena::Cli::SubcommandLoader.new('kontena/plugin/digital_ocean_command'))
