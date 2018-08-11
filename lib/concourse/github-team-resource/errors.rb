# frozen_string_literal: true

module Concourse
  module GitHubTeamResource
    class Unavailable < StandardError
      def initialize(error)
        super(error)
      end
    end

    class VersionUnavailable < StandardError
      def initialize(version, source)
        super("There is no version matching #{version} available at the source #{source}")
      end
    end
  end
end
