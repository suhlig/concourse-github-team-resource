# frozen_string_literal: true

require 'time'
require 'concourse/github-team-resource/base'
require 'concourse/github-team-resource/serializer'
require 'concourse/github-team-resource/errors'

module Concourse
  module GitHubTeamResource
    # https://concourse-ci.org/implementing-resources.html#in
    class In < Base
      def initialize(destination_directory)
        raise ArgumentError, 'No destination directory given' if destination_directory.nil?
        @serializer = Serializer.new(destination_directory)
      end

      def call(source, version, _params = nil)
        version = Time.parse(version.fetch('updated_at'))

        team = find_team(source)
        raise VersionUnavailable.new(version, source) unless team
        @serializer.serialize(team)
        to_json(team)
      end

      private

      def to_json(team)
        {
          'version'  => { 'updated_at' => team.updated_at },
          'metadata' => [
            { 'name'       => 'title', 'value' => team.title },
            { 'name'       => 'description', 'value' => team.description },
            { 'updated_at' => team.updated_at }
          ]
        }
      end
    end
  end
end
