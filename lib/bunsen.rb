require_relative 'bunsen/version'
require_relative 'bunsen/warmer'

module Bunsen
  class << self
    def version_string
      "bunsen v#{Bunsen::VERSION}"
    end
  end
end
