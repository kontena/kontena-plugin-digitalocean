require 'spec_helper'
require 'kontena/plugin/digital_ocean_command'

describe Kontena::Plugin::DigitalOcean::Master::CreateCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  let(:provisioner) do
    spy(:provisioner)
  end

  describe '#run' do
    it 'prompts user if options are missing' do
      expect(subject).to receive(:prompt).at_least(:once).and_return(spy)
      allow(subject).to receive(:provisioner).and_return(provisioner)
      subject.run(['--name', 'foo', '--skip-auth-provider'])
    end

    it 'passes options to provisioner' do
      options = [
        '--token', 'secretone',
        '--no-prompt',
        '--skip-auth-provider',
        '--region', 'sfo1',
        '--size', '2gb'
      ]
      expect(subject).to receive(:provisioner).with('secretone').and_return(provisioner)
      expect(provisioner).to receive(:run!).with(
        hash_including(ssh_key: '~/.ssh/id_rsa.pub')
      )
      subject.run(options)
    end
  end
end
