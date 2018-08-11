# frozen_string_literal: true

require 'concourse/github-team-resource/base'

module Concourse
  module GitHubTeamResource
    # https://concourse-ci.org/implementing-resources.html#out
    class Out < Base
      attr_reader :source_directory

      def initialize(source_directory)
        raise ArgumentError, 'No source directory given' if source_directory.nil?
        @source_directory = source_directory
      end

      def call(_source, _params = nil)
        # If this resource had output, we could do something with
        # the files in source_directory based on source, and potentially also
        # using params

        {
          'version'  => { 'updated_at' => nil },
          'metadata' => [
            { 'name' => 'comment', 'value' => "Neither has this resource any output, nor does it read from its sources in #{source_directory}." }
          ]
        }
      end
    end
  end
end
