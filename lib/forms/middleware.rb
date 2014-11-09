require 'middleware'
require 'uber/delegates'

module Forms
  class Middleware
    attr_reader :builder

    extend Uber::Delegates
    delegates :builder, :use, :stack

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