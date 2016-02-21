require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class RgxSpecTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_the_parms
    test = FormatEngine::FormatRgx.new("%/ABC/")
    assert_equal(0, test.width)
    assert_equal(/ABC/, test.regex)
    assert_equal('Regex("%/ABC/", "%/", /ABC/)', test.inspect)

    test = FormatEngine::FormatRgx.new("%*/ABC/")
    assert_equal(0, test.width)
    assert_equal(/ABC/, test.regex)
    assert_equal('Regex("%*/ABC/", "%*/", /ABC/)', test.inspect)

    test = FormatEngine::FormatRgx.new("%/ABC/x")
    assert_equal(0, test.width)
    assert_equal(/ABC/x, test.regex)
    assert_equal('Regex("%/ABC/x", "%/", /ABC/x)', test.inspect)

    test = FormatEngine::FormatRgx.new("%/ABC/i")
    assert_equal(0, test.width)
    assert_equal(/ABC/i, test.regex)
    assert_equal('Regex("%/ABC/i", "%/", /ABC/i)', test.inspect)

    test = FormatEngine::FormatRgx.new("%/ABC/m")
    assert_equal(0, test.width)
    assert_equal(/ABC/m, test.regex)
    assert_equal('Regex("%/ABC/m", "%/", /ABC/m)', test.inspect)

    test = FormatEngine::FormatRgx.new("%/ABC/xi")
    assert_equal(0, test.width)
    assert_equal(/ABC/ix, test.regex)
    assert_equal('Regex("%/ABC/xi", "%/", /ABC/ix)', test.inspect)

    test = FormatEngine::FormatRgx.new("%/ABC/mi")
    assert_equal(0, test.width)
    assert_equal(/ABC/mi, test.regex)
    assert_equal('Regex("%/ABC/mi", "%/", /ABC/mi)', test.inspect)

    test = FormatEngine::FormatRgx.new("%/ABC/xim")
    assert_equal(0, test.width)
    assert_equal(/ABC/ixm, test.regex)
    assert_equal('Regex("%/ABC/xim", "%/", /ABC/mix)', test.inspect)

  end
end
