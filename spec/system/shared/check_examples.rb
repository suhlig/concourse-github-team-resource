# frozen_string_literal: true

require 'json'

shared_examples 'check' do
  context 'the team cannot be found' do
    let(:input) do
      {
        "source": {
          'organization' => 'uhlig-it',
          'team' => 'does not exist',
          "access_token": ENV.fetch('GITHUB_TOKEN')
        },
        "version": { 'updated_at' => '2017-08-17 12:37:15 UTC' }
      }
    end

    before do
      last_command_started.write(input.to_json) && close_input
    end

    it 'bails out' do
      expect(last_command_started).to_not be_successfully_executed
    end

    it 'prints an error message' do
      stop_all_commands # required to read stderr
      expect(last_command_started.stderr).to include('Could not find team')
      expect(last_command_started.stdout).to be_empty
    end
  end

  context 'the first request' do
    let(:input) do
      {
        "source": {
          'organization' => 'uhlig-it',
          'team' => 'Concourse GitHub Team Resource Testers',
          "access_token": ENV.fetch('GITHUB_TOKEN')
        },
        "version": nil
      }
    end

    it 'responds with just the current version' do
      last_command_started.write(input.to_json) && close_input
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.stdout).to be_json
    end
  end

  context 'a consecutive request' do
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

    it 'responds with all versions since the requested one' do
      last_command_started.write(input.to_json) && close_input
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started.stdout).to be_json
    end
  end
end
