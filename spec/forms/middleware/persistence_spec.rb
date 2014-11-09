require 'spec_helper'

RSpec.describe Forms::Middleware::Persistence do
  describe '#initialize' do
    it 'initializes with a form object context' do
      form = Forms::Form.new
      context = form.context
    end
  end
end