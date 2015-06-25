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
    assert_equal(0, test.width)
    assert_equal(0, test.prec)

    test = FormatEngine::FormatVariable.new("%10B")
    assert_equal(10, test.width)
    assert_equal(0, test.prec)

    test = FormatEngine::FormatVariable.new("%10.5B")
    assert_equal(10, test.width)
    assert_equal(5, test.prec)
  end
end
