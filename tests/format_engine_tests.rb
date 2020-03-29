require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'

require_relative '../mocks/demo'

# A full test of the formatter/parser engine.
class FormatEngineTester < Minitest::Test

  def test_that_engines_are_returned
    assert_equal(FormatEngine::Engine, Customer.formatter_engine.class)
    assert_equal(FormatEngine::Engine, Customer.parser_engine.class)
  end

  def test_basic_formatting
    cust = Customer.new("Jane", "Doe", 21)

    assert_equal("Jane, Doe 21", cust.strfmt("%f, %l %a"))
  end

  def test_basic_parsing
    cust = Customer.strprs("Jane, Doe 21", "%f, %l %a")

    assert_equal(Customer, cust.class)
    assert_equal("Jane", cust.first_name)
    assert_equal("Doe", cust.last_name)
    assert_equal(21, cust.age)
  end

  def test_some_fancy_footwork
    cust = Customer.strprs("Wernher, von_Braun 104", "%f, %l %a")

    assert_equal(Customer, cust.class)
    assert_equal("Wernher", cust.first_name)
    assert_equal("von Braun", cust.last_name)
    assert_equal(104, cust.age)
  end

  def test_for_missing_data_detection
    assert_raises { Customer.strprs("Jane, Doe twenty", "%f, %l %a") }
    assert_raises { Customer.strprs("Jane", "%f, %l %a") }
    assert_raises { Customer.strprs("Jane, 34", "%f, %a") }
  end

end
