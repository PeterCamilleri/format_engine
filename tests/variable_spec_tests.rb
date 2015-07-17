require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class VariableSpecTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_it_validates
    engine = { "%A" => true }

    test = FormatEngine::FormatVariable.new("%A")
    assert_equal(test, test.validate(engine))

    test = FormatEngine::FormatVariable.new("%B")
    assert_raises(RuntimeError) { test.validate(engine) }
  end

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
end
