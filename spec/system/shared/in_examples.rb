# frozen_string_literal: true

shared_examples 'in' do
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

  it 'fetches the resource and responds with the fetched version and its metadata' do
    last_command_started.write(input.to_json) && close_input
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started.stdout).to be_json
  end
end
