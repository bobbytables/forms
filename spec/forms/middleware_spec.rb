require 'spec_helper'

RSpec.describe Forms::Middleware do
  describe '#initialize' do
    it 'initializes a builder' do
      instance = Forms::Middleware.new
      expect(instance.builder).to be_kind_of(Middleware::Builder)
    end
  end

  describe '#use' do
    subject(:middleware) { Forms::Middleware.new }

    it 'delegates to the underlying builder' do
      middleware.use -> { "Hello World" }
      expect(middleware.stack.size).to be(1)
    end
  end

  describe '#clone' do
    subject(:middleware) { Forms::Middleware.new }

    it 'performs a deep copy of the middleware object' do
      middleware.use -> { 'Hello World' }
      cloned = middleware.clone
      cloned.use -> { 'Goodbye World' }

      expect(middleware).to_not be(cloned)
      expect(middleware.stack.size).to be(1)
      expect(cloned.stack.size).to be(2)
    end
  end
end