module Forms
  class FormContext
    attr_accessor :attributes
    attr_accessor :valid
    attr_accessor :object
    attr_accessor :form_class

    def self.build_from(form)
      new.tap do |context|
        context.attributes = form.attributes.clone
        context.object = form.object.clone
        context.valid = form.valid?
        context.form_class = form.class
      end
    end

    def valid?
      !!valid
    end
  end
end