require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Contract.new.valid?
  end
end
