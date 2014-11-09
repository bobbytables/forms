require 'uber/inheritable_attr'
require 'active_model'

module Forms
  class Form
    include ActiveModel::Validations
    include Attributes
    extend Uber::InheritableAttribute

    attr_reader :attributes
    attr_reader :object
    attr_reader :options

    # The internal middleware stack for this form object
    inheritable_attr :middleware
    self.middleware = Forms::Middleware.new

    # The default method it uses to persist the object
    inheritable_attr :persist_method
    self.persist_method = 'save'

    # Context methods available to middlewares
    inheritable_attr :context_options
    self.context_options = []

    def initialize(*args)
      options = args.extract_options!

      @attributes = options.delete(:attributes) || {}
      @object     = options.delete(:object) || args[0] || DefaultObject.new
      @options    = options
    end

    def self.context(*contexts)
      self.context_options.concat(contexts)
    end

    def context
      FormContext.build_from(self)
    end

    def valid?
      true
    end

    def persist
      self.attributes.each do |key, value|
        object.send("#{key}=", value)
      end

      middleware = self.class.middleware
      middleware.call(context)

      context.valid?
    end
  end
end