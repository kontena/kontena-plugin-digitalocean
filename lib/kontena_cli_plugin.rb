require 'kontena_cli'
require_relative 'kontena/plugin/digital_ocean'
require_relative 'kontena/plugin/digital_ocean_command'

Kontena::MainCommand.register("digitalocean", "DigitalOcean specific commands", Kontena::Plugin::DigitalOceanCommand)
