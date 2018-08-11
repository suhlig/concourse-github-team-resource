# frozen_string_literal: true

require 'system/shared/check_examples'

describe 'when `check` is executed in a docker container', type: 'aruba' do
  before(:all) do
    `docker build -t suhlig/concourse-github-team-resource:latest .`
  end

  before do
    run 'docker run --rm --interactive suhlig/concourse-github-team-resource /opt/resource/check'
  end

  include_examples 'check'
end
