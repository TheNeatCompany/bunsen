require_relative 'lib/bunsen/version'

namespace :git do
  desc "create a git tag for the current version"
  task :tag_version do
    puts `git tag v#{Bunsen::VERSION}`
  end
end