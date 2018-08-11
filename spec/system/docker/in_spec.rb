# frozen_string_literal: true

require 'system/shared/in_examples'
require 'securerandom'
require 'concourse/github-team-resource/serializer'

describe 'when `in` is executed in a docker container', type: 'aruba' do
  let(:host_destination_directory) { "/tmp/#{SecureRandom.uuid}" }
  let(:container_destination_directory) { '/concourse' }
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

  before(:all) do
    `docker build -t suhlig/concourse-github-team-resource:latest .`
  end

  before do
    run "docker run --rm --interactive \
         --volume #{host_destination_directory}:#{container_destination_directory} \
         suhlig/concourse-github-team-resource \
         /opt/resource/in #{container_destination_directory}"
  end

  include_examples 'in'

  it 'fetches the resource and places it in the given directory' do
    last_command_started.write(input.to_json) && close_input
    expect(last_command_started).to be_successfully_executed

    # We don't necessarily have access to the docker host's file system from
    # this test, so we read back the version file by mounting another container
    # with the same volume as the one that created the file.
    files = `docker run --rm \
                  --volume #{host_destination_directory}:#{container_destination_directory} \
                  suhlig/concourse-github-team-resource \
                  ls #{container_destination_directory}`

    expected_file_count = Concourse::GitHubTeamResource::Serializer::ATTRIBUTES.size
    expect(files.lines.size).to eq(expected_file_count)
  end
end
