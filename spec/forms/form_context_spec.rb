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

      form_context = Forms::FormContext.build_from(form_object)

      expect(form_context.attributes).to eq(attributes)
      expect(form_context.attributes).to_not be(attributes)

      expect(form_context.valid).to eq(form_object.valid?)

      expect(form_context.object).to_not be(object)

      expect(form_context.form_class).to be(Forms::Form)
    end
  end

  describe '#valid' do
    subject(:form_context) { Forms::FormContext.new }

    it 'returns true when the context is true' do
      form_context.valid = true
      expect(form_context.valid?).to be_truthy
    end

    it 'returns false when the context is false' do
      form_context.valid = false
      expect(form_context.valid?).to be_falsey
    end
  end
end