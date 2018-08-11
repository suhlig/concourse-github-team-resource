# frozen_string_literal: true

describe Concourse::GitHubTeamResource do
  it 'has a version number' do
    expect(Concourse::GitHubTeamResource::VERSION).not_to be_empty
  end
end
