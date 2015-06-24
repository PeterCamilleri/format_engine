require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class LiteralSpecTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_it_validates_always
    test = FormatEngine::FormatLiteral.new("Test 1 2 3")
    assert_equal(test, test.validate(nil))
  end

end
