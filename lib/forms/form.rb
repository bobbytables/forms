require 'uber/inheritable_attr'

module Forms
  class Form
    extend Uber::InheritableAttribute

    attr_reader :attributes

    inheritable_attr :middleware
    self.middleware = Forms::Middleware.new

    def initialize(options = {})
      @attributes = options.fetch(:attributes, {})
    end
  end
end