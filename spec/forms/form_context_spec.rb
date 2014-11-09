require 'spec_helper'

RSpec.describe Forms::FormContext do
  describe 'Attributes' do
    it { is_expected.to respond_to(:attributes=).and respond_to(:attributes) }
    it { is_expected.to respond_to(:valid=).and respond_to(:valid) }
    it { is_expected.to respond_to(:object=).and respond_to(:object) }
    it { is_expected.to respond_to(:form_class=).and respond_to(:form_class) }
  end

  describe '.build_from' do
    it 'builds a context object from the form object' do
      attributes = { hello: 'world' }
      object = double('dummy model', save: true)

      form_object = Forms::Form.new(attributes: attributes, object: object)

      context = Forms::FormContext.build_from(form_object)

      expect(context.attributes).to eq(attributes)
      expect(context.attributes).to_not be(attributes)

      expect(context.valid).to eq(form_object.valid?)

      expect(context.object).to_not be(object)

      expect(context.form_class).to be(Forms::Form)
    end
  end

  describe '#valid' do
    subject(:context) { Forms::FormContext.new }

    it 'returns true when the context is true' do
      context.valid = true
      expect(context.valid?).to be_truthy
    end

    it 'returns false when the context is false' do
      context.valid = false
      expect(context.valid?).to be_falsey
    end
  end
end