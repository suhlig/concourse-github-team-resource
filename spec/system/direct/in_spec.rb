# frozen_string_literal: true

require 'system/shared/in_examples'
require 'concourse/github-team-resource/serializer'

describe 'when `in` is executed directly', type: 'aruba' do
  let(:destination_directory) { 'resource-destination' }
  let(:input) do
    {
      "source": {
        'organization' => 'uhlig-it',
        'team' => 'Concourse GitHub Team Resource Testers',
        "access_token": ENV.fetch('GITHUB_TOKEN')
      },
      "version": { 'updated_at' => '2017-08-17 12:37:15 UTC' }
    }
  end

  before do
    create_directory(destination_directory)
    run "resource/in #{destination_directory}"
  end

  include_examples 'in'

  it 'fetches the resource and places its artifacts in the given directory' do
    last_command_started.write(input.to_json) && close_input

    expect(last_command_started).to be_successfully_executed

    Concourse::GitHubTeamResource::Serializer::ATTRIBUTES.each do |attribute|
      attribute_file = File.join(destination_directory, attribute)
      expect(file?(attribute_file)).to be_truthy
    end
  end
end
