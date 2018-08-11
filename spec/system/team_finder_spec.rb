# frozen_string_literal: true

require 'concourse/github-team-resource/team_finder'
require 'octokit'

module Concourse
  module GitHubTeamResource
    describe TeamFinder do
      subject(:finder) { described_class.new(client, org_name) }
      let(:client) { Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN')) }

      context 'org exists' do
        let(:org_name) { 'uhlig-it' }

        context 'team exists' do
          it 'finds the team by its whole name' do
            VCR.use_cassette('existing-team') do
              expect(finder.find!('Concourse GitHub Team Resource Testers')).to be
            end
          end

          it 'finds the team by its partial, but unique name' do
            VCR.use_cassette('existing-team') do
              expect(finder.find!(/GitHub Team Resource/)).to be
            end
          end

          it 'does not return multiple matches' do
            VCR.use_cassette('existing-team') do
              expect { finder.find!(/.*/) }.to raise_error(MoreThanOneResult)
            end
          end
        end

        context 'team does not exist' do
          let(:team_name) { 'non-existing team' }

          it 'raises an error' do
            VCR.use_cassette('non-existing-team') do
              expect { finder.find!(team_name) }.to raise_error(NoSuchTeam)
            end
          end
        end
      end

      context 'org does NOT exist' do
        let(:org_name) { 'non-existing org' }

        it 'raises an error' do
          VCR.use_cassette('non-existing-org') do
            expect { finder.find!('unrelated') }.to raise_error(NoSuchOrganization)
          end
        end
      end
    end
  end
end
