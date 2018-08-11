# frozen_string_literal: true

require 'octokit'
require 'concourse/github-team-resource/team_finder'

module Concourse
  module GitHubTeamResource
    class Base
      def find_team(source)
        if source.key?('api_endpoint')
          Octokit.configure do |c|
            c.api_endpoint = source.fetch('api_endpoint')
          end
        end

        client = Octokit::Client.new(access_token: source.fetch('access_token'))
        finder = TeamFinder.new(client, source.fetch('organization'))
        finder.find!(source.fetch('team'))
      end
    end
  end
end
