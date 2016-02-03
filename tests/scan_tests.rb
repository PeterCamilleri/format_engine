require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'


# Test the internals of the parser engine. This is not the normal interface.
class ScanTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def make_parser
    FormatEngine::Engine.new(
      "%d"    => lambda do
        dst << found.to_i if parse(fmt.regex("\\d"))
      end,

      "%*d"   => lambda do
        parse(fmt.regex("\\d"))
      end,

      "%["    => lambda do
        dst << found if parse(fmt.regex)
      end,

      "%*["   => lambda do
        parse(fmt.regex)
      end)
  end

  def test_that_it_can_scan
    engine = make_parser
    spec = "%d %2d %4d"
    result = engine.do_parse("12 34 56", [], spec)

    assert_equal(Array, result.class)
    assert_equal([12, 34, 56] , result)
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
