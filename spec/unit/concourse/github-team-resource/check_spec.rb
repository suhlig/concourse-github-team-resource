# frozen_string_literal: true

require 'concourse/github-team-resource/check'

module Concourse
  module GitHubTeamResource
    describe Check do
      subject(:check) { described_class.new }

      let(:source) do
        {
          'organization' => 'Einhornstandarte',
          'team' => 'Moderatoren',
          'access_token' => 'redacted'
        }
      end

      let(:current_version) { Time.parse('2017-08-17 12:37:15 UTC') }

      let(:team) do
        double(updated_at: current_version)
      end

      before do
        allow_any_instance_of(TeamFinder).to receive('find!').and_return(team)
      end

      context 'there is no newer version than the current one' do
        context 'first request (without a current version)' do
          let(:version) { nil }

          it 'responds with just the current version' do
            output = check.call(source, version)
            expect(output).to eq([{ 'updated_at' => current_version }])
          end
        end

        context 'consecutive request (including the current version)' do
          let(:version) { { 'updated_at' => current_version } }

          it 'responds with just the current version' do
            output = check.call(source, version)
            expect(output).to eq([{ 'updated_at' => current_version }])
          end
        end
      end

      context 'there are newer versions than the current one' do
        context 'first request (without a current version)' do
          let(:version) { nil }

          it 'responds with just the current version' do
            output = check.call(source, version)
            expect(output).to eq([{ 'updated_at' => current_version }])
          end
        end

        context 'consecutive request (including the current version)' do
          let(:version) { { 'updated_at' => current_version - 12 } }

          it 'responds with all versions since the requested one (but there is only the latest one)' do
            output = check.call(source, version)

            expect(output).to eq([{ 'updated_at' => current_version }])
          end
        end
      end

      shared_examples 'unknown org or team' do |expected_error|
        context 'first request (without a current version)' do
          let(:version) { nil }

          it 'raises an error' do
            expect { check.call(source, version) }.to raise_error(expected_error)
          end
        end

        context 'consecutive request (including the current version)' do
          let(:version) { { 'updated_at' => current_version } }

          it 'raises an error' do
            expect { check.call(source, version) }.to raise_error(expected_error)
          end
        end
      end

      context 'the team is not found' do
        before do
          allow_any_instance_of(TeamFinder).to receive('find!').and_raise(NoSuchTeam.new('known-org', 'unknown-team'))
        end

        include_examples 'unknown org or team', NoSuchTeam
      end

      context 'the org is not found' do
        before do
          allow_any_instance_of(TeamFinder).to receive('find!').and_raise(NoSuchOrganization.new('unknown-org'))
        end

        include_examples 'unknown org or team', NoSuchOrganization
      end
    end
  end
end
