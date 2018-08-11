# frozen_string_literal: true

require 'concourse/github-team-resource/base'

module Concourse
  module GitHubTeamResource
    # https://concourse-ci.org/implementing-resources.html#resource-check
    class Check < Base
      def call(source, _version)
        [{ 'updated_at' => find_team(source).updated_at }]
      end
    end
  end
end
