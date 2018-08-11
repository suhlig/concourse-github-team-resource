# frozen_string_literal: true

require 'securerandom'

shared_examples 'out' do
  let(:resource_contents) { SecureRandom.uuid }
  let(:input) do
    {
      "source": {
        "organization" => 'uhlig-it',
        "team" => 'Concourse GitHub Team Resource Testers',
        "access_token": ENV.fetch('GITHUB_TOKEN')
      },
      "version": { "updated_at" => '2017-08-17 12:37:15 UTC' }
    }
  end

  it 'idempotently pushes a version up' do
    last_command_started.write(input.to_json) && close_input
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started.stdout).to be_json
  end
end
