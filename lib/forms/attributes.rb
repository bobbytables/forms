module Forms
  module Attributes
    def self.included(base)
      base.extend ClassMethods
      base.inheritable_attr :attributes
      base.attributes = []
    end

    module ClassMethods
      def attribute(*names)
        names.each do |name|
          name = name.to_sym
          attributes << name

          define_method name do
            attributes[name]
          end
        end
      end
    end
  end
end