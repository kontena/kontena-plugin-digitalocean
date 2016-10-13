require 'securerandom'
require_relative '../prompts'

module Kontena::Plugin::DigitalOcean::Master
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Plugin::DigitalOcean::Prompts

    option "--name", "[NAME]", "Set master name"
    option "--token", "TOKEN", "DigitalOcean API token", environment_variable: "DO_TOKEN" 
    option "--region", "REGION", "Region"
    option "--size", "SIZE", "Droplet size"
    option "--ssh-key", "SSH_KEY", "Path to ssh public key", default: '~/.ssh/id_rsa.pub'
    option "--ssl-cert", "SSL CERT", "SSL certificate file"
    option "--vault-secret", "VAULT_SECRET", "Secret key for Vault (optional)"
    option "--vault-iv", "VAULT_IV", "Initialization vector for Vault (optional)"
    option "--mongodb-uri", "URI", "External MongoDB uri (optional)"
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'


    def execute
      do_token = ask_do_token

      require_relative '../../../machine/digital_ocean'

      do_region = ask_droplet_region(do_token)
      do_size = ask_droplet_size(do_token, do_region)

      provisioner = provisioner(do_token)
      provisioner.run!(
          ssh_key: ssh_key,
          ssl_cert: ssl_cert,
          size: do_size,
          region: do_region,
          version: version,
          vault_secret: vault_secret || SecureRandom.hex(24),
          vault_iv: vault_iv || SecureRandom.hex(24),
          initial_admin_code: SecureRandom.hex(16),
          mongodb_uri: mongodb_uri
      )
    end

    # @param [String] token
    def provisioner(token)
      Kontena::Machine::DigitalOcean::MasterProvisioner.new(token)
    end
  end
end
