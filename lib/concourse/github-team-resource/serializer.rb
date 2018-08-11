# frozen_string_literal: true

module Concourse
  module GitHubTeamResource
    class Serializer
      ATTRIBUTES = %w[id name description updated_at].freeze

      def initialize(directory)
        @directory = directory
      end

      def serialize(item)
        ATTRIBUTES.each do |attribute|
          File.write(File.join(@directory, attribute), item.send(attribute))
        end
      end
    end
  end
end
