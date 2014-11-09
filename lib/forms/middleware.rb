require 'middleware'
require 'uber/delegates'

# Default middlewares
require 'forms/middleware/persistence'

module Forms
  class Middleware
    attr_reader :builder

    extend Uber::Delegates
    delegates :builder, :use, :stack, :call

    def initialize
      @builder = ::Middleware::Builder.new
    end

    def clone
      cloned = self.class.new
      cloned.use builder
      cloned
    end
  end
end