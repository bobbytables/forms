require 'spec_helper'

RSpec.describe Forms::DefaultObject do
  describe '#initialize' do
    it 'initializes with a method name for persistence' do
      instance = Forms::DefaultObject.new persist_method: 'bunk'
      expect(instance).to respond_to :bunk
    end
  end

  describe 'Persistence Method' do
    it 'raises when calling the persistence method' do
      instance = Forms::DefaultObject.new(persist_method: 'save')
      expect { instance.save }.to raise_error(NoMethodError, "You must pass in an object that responds to `#save`")
    end

    it 'defaults the persist method to save' do
      instance = Forms::DefaultObject.new
      expect(instance).to respond_to :save
    end
  end
end