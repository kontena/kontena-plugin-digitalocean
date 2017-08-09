class Kontena::Plugin::DigitalOceanCommand < Kontena::Command
  subcommand 'master', 'DigitalOcean master related commands', load_subcommand('kontena/plugin/digital_ocean/master_command')
  subcommand 'node', 'DigitalOcean node related commands', load_subcommand('kontena/plugin/digital_ocean/node_command')
end
