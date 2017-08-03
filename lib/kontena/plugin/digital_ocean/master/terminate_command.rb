module Kontena::Plugin::DigitalOcean::Master
  class TerminateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Plugin::DigitalOcean::Prompts

    parameter "NAME", "Master name"
    option "--token", "TOKEN", "DigitalOcean API token", environment_variable: "DO_TOKEN"
    option "--force", :flag, "Force remove", default: false, attribute_name: :forced

    def execute
      suppress_warnings # until DO merges resource_kit pr #32
      do_token = ask_do_token
      confirm_command(name) unless forced?

      require_relative '../../../machine/digital_ocean'
      destroyer = destroyer(do_token)
      destroyer.run!(name)
    ensure
      resume_warnings
    end

    # @param [String] token
    def destroyer(token)
      Kontena::Machine::DigitalOcean::MasterDestroyer.new(token)
    end
  end
end
