require 'spec_helper'
require 'ostruct'

RSpec.describe Forms::Form do
  describe '#initialize' do
    it 'accepts an attributes option' do
      instance = Forms::Form.new(attributes: { hello: 'world' })
      expect(instance.attributes).to eq(hello: 'world')
    end

    it 'defaults attributes to an empty hash if passed nothing' do
      instance = Forms::Form.new
      expect(instance.attributes).to be_a(Hash).and eq({})
    end

    it 'accepts an object to later on persist' do
      object = double
      instance = Forms::Form.new(object: object)

      expect(instance.object).to be(object)
    end

    it 'returns a default object' do
      instance = Forms::Form.new
      expect(instance.object).to be_a(Forms::DefaultObject)
    end

    it 'assigns options for anything else passed in' do
      user = double
      instance = Forms::Form.new(current_user: user)
      expect(instance.options[:current_user]).to be(user)
    end
  end

  describe '.middleware' do
    subject(:klass) { Class.new(Forms::Form) }

    it 'returns the middleware stack' do
      expect(klass.middleware).to be_a(Forms::Middleware)
    end

    context 'inheritance' do
      let(:inherited) { Class.new(klass) }

      it 'duplicates the middleware stack in order to not modify super class stacks' do
        m1 = -> {}
        m2 = -> {}

        klass.middleware.use m1
        inherited.middleware.use m2

        expect(klass.middleware.stack.size).to be(1)
        expect(inherited.middleware.stack.size).to be(2)
      end
    end
  end

  describe '.persist_method' do
    it 'is defaulted to #save' do
      expect(Forms::Form.persist_method).to eq('save')
    end
  end

  describe '.context' do
    subject(:form) { Class.new(Forms::Form) }

    it 'adds a method to list of contexts' do
      form.context :current_user
      expect(form.context_options).to include(:current_user)
    end
  end

  describe '#persist' do
    let(:form_class) do
      Class.new(Forms::Form) do
        middleware.use Forms::Middleware::Persistence
      end
    end

    it 'persists the object from the form' do
      object = double.as_null_object
      form = form_class.new(object: object, attributes: { hello: 'world' })

      expect(object).to receive(:save).once

      form.persist
    end

    it 'uses the method defined on the form object to perist' do
      form_class.persist_method = 'bunk'

      object = double.as_null_object
      form = form_class.new(object: object, attributes: { hello: 'world' })

      expect(object).to receive(:bunk).once

      form.persist
    end
  end

  describe '#context' do
    it 'returns a context object for the current state' do
      object = double
      form = Forms::Form.new(object: object, attributes: { hello: 'world' })

      expect(form.context).to be_kind_of(Forms::FormContext)
    end
  end
end