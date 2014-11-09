require 'uber/delegates'

module Forms
  class FormContext
    extend Uber::Delegates

    attr_accessor :attributes
    attr_accessor :valid
    attr_accessor :object
    attr_accessor :form_class
    attr_accessor :form

    delegates :form, :errors

    def self.build_from(form)
      context = new
      context.attributes = form.attributes.clone
      context.object     = form.object.clone
      context.valid      = form.valid?
      context.form_class = form.class
      context.form       = form

      # Add all of the form context methods (such as current_user)
      context.create_context_methods
      context
    end

    def valid?
      !!valid
    end

    def create_context_methods
      form_class.context_options.each do |method_name|
        instance_eval <<-CONTEXT_METHOD
          def self.#{method_name}
            form.options[:#{method_name}]
          end
        CONTEXT_METHOD
      end
    end
  end
end