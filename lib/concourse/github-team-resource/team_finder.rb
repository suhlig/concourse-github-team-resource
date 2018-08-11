# frozen_string_literal: true

require 'time'
require 'octokit'

module Concourse
  module GitHubTeamResource
    NoSuchOrganization = Class.new(StandardError) do
      def initialize(name)
        super("Could not find organization #{name}")
      end
    end

    NoSuchTeam = Class.new(StandardError) do
      def initialize(org_name, name)
        super("Could not find team '#{name}' in organization #{org_name}")
      end
    end

    MoreThanOneResult = Class.new(StandardError) do
      def initialize(org_name, name, count)
        super("Expected exactly one, but found #{count} teams matching #{name} in the organization #{org_name}")
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    TeamFinder = Struct.new(:client, :org_name) do
      def find!(pattern)
        begin
          organization = client.organization(org_name)
        rescue Octokit::NotFound
          raise NoSuchOrganization, org_name
        end

        teams = client.org_teams(organization.id)
        selected_teams = teams.select { |team| pattern.match(team.name) }

        case selected_teams.size
        when 0
          raise NoSuchTeam.new(org_name, pattern)
        when 1
          client.team(selected_teams.first.id)
        else
          raise MoreThanOneResult.new(org_name, pattern, selected_teams.size)
        end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
    end
  end
end
