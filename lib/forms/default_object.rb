module Forms
  class DefaultObject
    def initialize(options = {})
      persist_method = options.fetch(:persist_method, 'save')

      instance_eval <<-PERSIST
        def self.#{persist_method}
          raise NoMethodError, "You must pass in an object that responds to `##{persist_method}`"
        end
      PERSIST
    end
  end
end