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
end