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

end
