# Forms

Forms is a different approach to accepting user input. It allows you to avoid Callback Hell™ that traditional apps sometimes end up in.
By implementing a middleware type of system, you can avoid `before_save`, and `after_commit` to perform operations out of scope from the model being saved itself.

For example, you may want to perform an audit action after a model is saved by creating a `Audit.create(name: 'profile_update', user: current_user)`.
While this could be in the model, you then have the problem of every time you create an object, this operation will occur.
This slows down tests, sometimes will make test setup massive, pretty soon you're stubbing `Audtion.create` to be a noop. Bad news.

Instead, Forms allows you to just put this into a form object that accepts user data.

##### FormObject #save Call

Lets say we want to set attributes on the object being set, or even stop the call completely because a prerequisite was not made? Validations are great, but sometimes a validation simply has TOO MUCH behavior in a model.

```ruby
class PromoPolicy
  def initialize(app)
    @app = app
  end

  # Validate this user has not used this promo and the code is valid
  def can_apply_code?(user, code)
    !user.applied_promos.include?(code) and Promo.valid_code?(code)
  end

  def call(context)
    can_apply = can_apply_code?(context.current_user, context.attributes[:code])

    if can_apply
      @app.call(context)
    else
      context.valid = false
      context.errors << "Cannot apply promo code"
    end
  end
end

class PromoAuditOperation
  def initialize(app)
    @app = app
  end

  def call(context)
    Audit.create(auditable: context.model, actor: context.user, comment: "Applied promo code: #{context.params[:code]}")
  end
end

class PromoForm < Forms::Form
  middleware.use PromoPolicy
  middleware.use Forms::Middleware::Persistence
  middleware.use AuditOperation

  context :current_user

  attribute :code

  validates :code, presence: true
end


form = PromoForm.new(Promo.new, attributes: params[:promo], user: current_user)
form.save
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'forms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install forms

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/forms/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
