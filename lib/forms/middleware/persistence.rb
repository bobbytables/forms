module Forms
  class Middleware
    class Persistence
      def initialize(app)
        @app = app
      end

      def call(context)
        save_method = context.form_class.persist_method
        persisted = context.object.send(save_method)

        if persisted
          @app.call(context)
        else
          context.valid = persisted
        end
      end
    end
  end
end