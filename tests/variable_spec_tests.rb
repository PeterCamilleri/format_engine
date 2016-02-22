require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class VariableSpecTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_the_parms
    test = FormatEngine::FormatVariable.new("%B")
    refute(test.has_width?)
    assert_equal(0, test.width)
    assert_equal("", test.width_str)
    refute(test.has_prec?)
    assert_equal(0, test.prec)
    assert_equal("", test.prec_str)
    assert_equal("", test.parm_str)

    test = FormatEngine::FormatVariable.new("%10B")
    assert(test.has_width?)
    assert_equal(10, test.width)
    assert_equal("10", test.width_str)
    refute(test.has_prec?)
    assert_equal(0, test.prec)
    assert_equal("", test.prec_str)
    assert_equal("10", test.parm_str)

    test = FormatEngine::FormatVariable.new("%10.5B")
    assert(test.has_width?)
    assert_equal(10, test.width)
    assert_equal("10", test.width_str)
    assert(test.has_prec?)
    assert_equal(5, test.prec)
    assert_equal("5", test.prec_str)
    assert_equal("10.5", test.parm_str)

    test = FormatEngine::FormatVariable.new("%-10.5B")
    assert(test.has_width?)
    assert_equal(-10, test.width)
    assert_equal("-10", test.width_str)
    assert(test.has_prec?)
    assert_equal(5, test.prec)
    assert_equal("5", test.prec_str)
    assert_equal("-10.5", test.parm_str)

  end

  def test_unsupported_methods
    test = FormatEngine::FormatVariable.new("%B")

    assert_raises() {test.regex}
  end

end
