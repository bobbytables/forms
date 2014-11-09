require 'spec_helper'

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
      expect(Forms::Form.persist_method).to be(:save)
    end
  end

  describe '.context' do
    subject(:form) { Class.new(Forms::Form) }

    it 'adds a method to list of contexts' do
      form.context :current_user
      expect(form.context_options).to include(:current_user)
    end
  end
end