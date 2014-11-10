require 'uber/inheritable_attr'
require 'active_model'

module Forms
  class Form
    extend Uber::InheritableAttribute
    include ActiveModel::Validations
    include Attributes

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
      @object     = args[0] || DefaultObject.new
      @options    = options
    end

    def self.context(*contexts)
      self.context_options.concat(contexts)
    end

    def context
      FormContext.build_from(self)
    end

    def persist
      self.class.attributes.each do |key|
        object.send("#{key}=", send(key))
      end

      middleware = self.class.middleware
      middleware.call(context)

      context.valid?
    end
  end
end