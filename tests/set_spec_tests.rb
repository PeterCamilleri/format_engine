require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class SetSpecTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_the_parms
    test = FormatEngine::FormatSet.new("%[ABC]")
    assert_equal(0, test.width)
    assert_equal(/[ABC]+/, test.regex)

    test = FormatEngine::FormatSet.new("%10[ABC]")
    assert_equal(0, test.width)
    assert_equal(/[ABC]{1,10}/, test.regex)

    test = FormatEngine::FormatSet.new("%5,10[ABC]")
    assert_equal(0, test.width)
    assert_equal(/[ABC]{5,10}/, test.regex)

    test = FormatEngine::FormatSet.new("%0,10[ABC]")
    assert_equal(0, test.width)
    assert_equal(/[ABC]{0,10}/, test.regex)

  end

  def test_unsupported_methods
    test = FormatEngine::FormatSet.new("%[ABC]")

    assert_raises() {test.has_width?}
    assert_raises() {test.width_str}
    assert_raises() {test.has_prec?}
    assert_raises() {test.prec}
    assert_raises() {test.prec_str}
    assert_raises() {test.parm_str}
  end

end
