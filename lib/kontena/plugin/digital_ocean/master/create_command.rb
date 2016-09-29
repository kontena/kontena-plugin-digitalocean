require 'securerandom'

module Kontena::Plugin::DigitalOcean::Master
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common

    option "--name", "[NAME]", "Set master name"
    option "--token", "TOKEN", "DigitalOcean API token", required: true
    option "--ssh-key", "SSH_KEY", "Path to ssh public key", default: '~/.ssh/id_rsa.pub'
    option "--ssl-cert", "SSL CERT", "SSL certificate file"
    option "--size", "SIZE", "Droplet size", default: '1gb'
    option "--region", "REGION", "Region", default: 'ams2'
    option "--vault-secret", "VAULT_SECRET", "Secret key for Vault (optional)"
    option "--vault-iv", "VAULT_IV", "Initialization vector for Vault (optional)"
    option "--mongodb-uri", "URI", "External MongoDB uri (optional)"
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'


    def execute
      require_relative '../../../machine/digital_ocean'

      provisioner = provisioner(token)
      provisioner.run!(
          ssh_key: ssh_key,
          ssl_cert: ssl_cert,
          size: size,
          region: region,
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
