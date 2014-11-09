module Forms
  module Attributes
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute(*names)
        names.each do |name|
          name = name.to_sym

          define_method name do
            attributes[name]
          end
        end
      end
    end
  end
end