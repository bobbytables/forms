require 'forms'

class RegistrationPolicy
  def initialize(app)
    @app = app
  end

  def call(context)
    email = context.attributes[:email]
    unless email && email.end_with?('@creativequeries.com')
      context.errors.add(:email, "Must end with the right domain")
    else
      @app.call(context)
    end
  end
end

class UserRegistationForm < Forms::Form
  attribute :email
  attribute :password

  middleware.use RegistrationPolicy
  middleware.use Forms::Middleware::Persistence
end

class User
  attr_accessor :email
  attr_accessor :password

  # This will never hit unless the middleware for registration policy passes
  def save
    puts inspect
  end
end

form = UserRegistationForm.new(User.new, attributes: { email: "bobbytables@example.com" })
form.persist

puts form.errors.to_a