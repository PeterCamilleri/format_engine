require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'


# Test the internals of the parser engine. This is not the normal interface.
class ScanTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  DECIMAL = /[+-]?\d+/
  INTEGER = /[+-]?(0x)?\d+/

  def make_parser
    FormatEngine::Engine.new(
      "%d"  => lambda {parse(DECIMAL) ? dst << found.to_i : :break},
      "%*d" => lambda {parse(DECIMAL) || :break},
      "%i"  => lambda {parse(INTEGER) ? dst << Integer(found) : :break},
      "%*i" => lambda {parse(INTEGER) || :break},
      "%["  => lambda {parse(fmt.regex) ? dst << found : :break},
      "%*[" => lambda {parse(fmt.regex) || :break})
  end

  def test_that_it_can_scan
    engine = make_parser
    spec = "%d %2d %4d"
    result = engine.do_parse("12 34 -56", [], spec)
    assert_equal(Array, result.class)
    assert_equal([12, 34, -56] , result)

    spec = "%i %i %i"
    result = engine.do_parse("77 077 0x77", [], spec)
    assert_equal(Array, result.class)
    assert_equal([77, 63, 119] , result)
  end

  def test_missing_data
    engine = make_parser
    spec = "%d %2d %4d %d"
    result = engine.do_parse("12 34 56", [], spec)

    assert_equal(Array, result.class)
    assert_equal([12, 34, 56] , result)
  end

  def test_excess_data
    engine = make_parser
    spec = "%d %2d %4d"
    result = engine.do_parse("12 34 56 78", [], spec)

    assert_equal(Array, result.class)
    assert_equal([12, 34, 56] , result)
  end

  def test_malformed_data
    engine = make_parser
    spec = "%d %d %d"
    result = engine.do_parse("12 igloo 34 56", [], spec)

    assert_equal(Array, result.class)
    assert_equal([12] , result)
  end

  def test_skipped_data
    engine = make_parser
    spec = "%d %2d %*d %d"
    result = engine.do_parse("12 34 56 78", [], spec)

    assert_equal(Array, result.class)
    assert_equal([12, 34, 78] , result)
  end

  def test_packed_data
    engine = make_parser
    spec = "%2d %2d %2d"
    result = engine.do_parse("123456", [], spec)

    assert_equal(Array, result.class)
    assert_equal([12, 34, 56] , result)
  end

  def test_some_sets
    engine = make_parser
    spec = "%5[truefals] %5[truefals] %5[truefals]"
    result = engine.do_parse("true false true", [], spec)

    assert_equal(Array, result.class)
    assert_equal(["true", "false", "true"] , result)
  end

  def test_some_sets_with_skips
    engine = make_parser
    spec = "%5[truefals] %*5[truefals] %5[truefals]"
    result = engine.do_parse("true false true", [], spec)

    assert_equal(Array, result.class)
    assert_equal(["true", "true"] , result)
  end

end
