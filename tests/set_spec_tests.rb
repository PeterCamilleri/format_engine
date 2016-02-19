require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class SetSpecTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_the_parms
    test = FormatEngine::FormatSet.new("%[B]")
    assert_equal(0, test.width)
    assert_equal(/[B]+/, test.regex)

    test = FormatEngine::FormatSet.new("%10[B]")
    assert_equal(0, test.width)
    assert_equal(/[B]{1,10}/, test.regex)

    test = FormatEngine::FormatSet.new("%5,10[B]")
    assert_equal(0, test.width)
    assert_equal(/[B]{5,10}/, test.regex)

  end
end
