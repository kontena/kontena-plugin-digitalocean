require 'spec_helper'
require 'kontena/plugin/digital_ocean_command'

describe Kontena::Plugin::DigitalOcean::Nodes::CreateCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  let(:provisioner) do
    spy(:provisioner)
  end

  let(:client) do
    spy(:client)
  end

  describe '#run' do
    before(:each) do
      allow(subject).to receive(:require_current_grid).and_return('test-grid')
      allow(subject).to receive(:require_api_url).and_return('http://master.example.com')
      allow(subject).to receive(:api_url).and_return('http://master.example.com')
      allow(subject).to receive(:require_token).and_return('12345')
      allow(subject).to receive(:fetch_grid).and_return({})
      allow(subject).to receive(:client).and_return(client)
    end

    it 'prompts user if options are missing' do
      allow(subject).to receive(:provisioner).and_return(spy)
      expect(subject).to receive(:prompt).and_return(spy).at_least(:once)
      subject.run([])
    end

    it 'passes options to provisioner' do
      options = [
        '--token', 'secretone',
        '--region', 'ams2',
        '--size', '4gb',
        '--count', 2
      ]
      expect(subject).to receive(:provisioner).with(client, 'secretone').and_return(provisioner)
      expect(provisioner).to receive(:run!).with(
        hash_including(
          ssh_key: '~/.ssh/id_rsa.pub',
          region: 'ams2',
          size: '4gb',
          count: 2
        )
      )
      subject.run(options)
    end
  end
end
