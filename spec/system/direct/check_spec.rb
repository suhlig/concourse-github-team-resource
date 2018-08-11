# frozen_string_literal: true

require 'system/shared/check_examples'

describe 'when `check` is executed directly', type: 'aruba' do
  before do
    run 'resource/check'
  end

  include_examples 'check'
end
