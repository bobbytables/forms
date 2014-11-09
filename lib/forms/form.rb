require 'uber/inheritable_attr'

module Forms
  class Form
    extend Uber::InheritableAttribute

    attr_reader :attributes
    attr_reader :object

    # The internal middleware stack for this form object
    inheritable_attr :middleware
    self.middleware = Forms::Middleware.new

    # The default method it uses to persist the object
    inheritable_attr :persist_method
    self.persist_method = :save

    def initialize(options = {})
      @attributes = options.fetch(:attributes, {})
      @object     = options.fetch(:object, DefaultObject.new)
    end
  end
end