require 'kontena/plugin/digital_ocean/prompts'

module Kontena::Plugin::DigitalOcean::Master
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Plugin::DigitalOcean::Prompts

    option "--name", "[NAME]", "Set master name"
    option "--token", "TOKEN", "DigitalOcean API token", environment_variable: "DO_TOKEN"
    option "--region", "REGION", "Region"
    option "--size", "SIZE", "Droplet size"
    option "--ssh-key", "SSH_KEY", "Path to ssh public key"
    option "--ssl-cert", "SSL CERT", "SSL certificate file"
    option "--vault-secret", "VAULT_SECRET", "Secret key for Vault (optional)"
    option "--vault-iv", "VAULT_IV", "Initialization vector for Vault (optional)"
    option "--mongodb-uri", "URI", "External MongoDB uri (optional)"
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'

    def execute
      suppress_warnings # until DO merges resource_kit pr #32
      do_token = ask_do_token

      require 'securerandom'
      require 'kontena/machine/digital_ocean'

      do_token = ask_do_token
      do_region = ask_droplet_region(do_token)
      do_size = ask_droplet_size(do_token, do_region)
      do_ssh_key_id = ask_ssh_key(do_token)

      provisioner = provisioner(do_token)
      provisioner.run!(
        name: name,
        ssh_key_id: do_ssh_key_id,
        ssl_cert: ssl_cert,
        size: do_size,
        region: do_region,
        version: version,
        vault_secret: vault_secret || SecureRandom.hex(24),
        vault_iv: vault_iv || SecureRandom.hex(24),
        initial_admin_code: SecureRandom.hex(16),
        mongodb_uri: mongodb_uri
      )
    ensure
      resume_warnings
    end

    # @param [String] token
    def provisioner(token)
      Kontena::Machine::DigitalOcean::MasterProvisioner.new(token)
    end
  end
end
