require 'forms'

class UserRegistationForm < Forms::Form
  attribute :email
  attribute :password

  middleware.use Forms::Middleware::Persistence
end

class User
  attr_accessor :email
  attr_accessor :password

  def save
    puts inspect
  end
end

form = UserRegistationForm.new(User.new, attributes: { email: "bobbytables@example.com" })
form.persist