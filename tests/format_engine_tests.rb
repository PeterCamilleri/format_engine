require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

require_relative '../mocks/demo'

# A full test of the formatter/parser engine.
class FormatEngineTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_basic_formatting
    cust = Customer.new("Jane", "Doe")

    assert_equal("Jane, Doe", cust.strfmt("%f, %l"))
  end

end
