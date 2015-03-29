guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  files.each { |file| watch(helper.real_path(file)) }
end

guard :rspec, cmd: "bundle exec rspec --color" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  watch(%r{^lib/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
end
