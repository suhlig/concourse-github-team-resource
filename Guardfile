# frozen_string_literal: true

guard 'bundler' do
  watch('Gemfile')
end

guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # When a shared example was changed, run just the correspondig specs in direct and docker
  watch(%r{^spec/system/shared/(.+)_examples\.rb$}) do |m|
    %w[direct docker].map { |type| "spec/system/#{type}/#{m[1]}_spec.rb" }
  end
  watch(%r{^resource/(.+)$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch(%r{^lib/.+/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }

  dsl.watch_spec_files_for(dsl.ruby.lib_files)
end
