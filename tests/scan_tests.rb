require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'


# Test the internals of the parser engine. This is not the normal interface.
class ScanTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  DECIMAL  = /[+-]?\d+/
  HEX      = /[+-]?(0[xX])?\h+/
  OCTAL    = /[+-]?(0[oO])?[0-7]+/
  BINARY   = /[+-]?(0[bB])?[01]+/
  INTEGER  = /[+-]?((0[xX]\h+)|(0[bB][01]+)|(0[oO]?[0-7]*)|([1-9]\d*))/
  FLOAT    = /[+-]?\d+(\.\d+)?([eE][+-]?\d+)?/
  RATIONAL = /[+-]?\d+\/\d+(r)?/
  COMPLEX  = %r{(?<num> \d+(\.\d+)?([eE][+-]?\d+)?){0}
                [+-]?\g<num>[+-]\g<num>[ij]
               }x
  QUOTED   = /("([^\\"]|\\.)*")|('([^\\']|\\.)*')/

  def make_parser
    FormatEngine::Engine.new(
      "%b"  => lambda {parse(BINARY) ? dst << found.to_i(2) : :break},
      "%*b" => lambda {parse(BINARY) || :break},

      "%c"  => lambda {dst << grab},
      "%*c" => lambda {grab},

      "%d"  => lambda {parse(DECIMAL) ? dst << found.to_i : :break},
      "%*d" => lambda {parse(DECIMAL) || :break},

      "%f"  => lambda {parse(FLOAT) ? dst << found.to_f : :break},
      "%*f" => lambda {parse(FLOAT) || :break},

      "%i"  => lambda {parse(INTEGER) ? dst << found.to_i(0) : :break},
      "%*i" => lambda {parse(INTEGER) || :break},

      "%j"  => lambda {parse(COMPLEX) ? dst << Complex(found) : :break},
      "%*j" => lambda {parse(COMPLEX) || :break},

      "%o"  => lambda {parse(OCTAL) ? dst << found.to_i(8) : :break},
      "%*o" => lambda {parse(OCTAL) || :break},

      "%q"  => lambda do
        parse(QUOTED) ? dst << found[1..-2].gsub(/\\./) {|seq| seq[-1]} : :break
      end,
      "%*q" => lambda {parse(QUOTED) || :break},

      "%r"  => lambda {parse(RATIONAL) ? dst << found.to_r : :break},
      "%*r" => lambda {parse(RATIONAL) || :break},

      "%s"  => lambda {parse(/\S+/) ? dst << found : :break},
      "%*s" => lambda {parse(/\S+/) || :break},

      "%u"  => lambda {parse(/\d+/) ? dst << found.to_i : :break},
      "%*u" => lambda {parse(/\d+/) || :break},

      "%x"  => lambda {parse(HEX) ? dst << found.to_i(16) : :break},
      "%*x" => lambda {parse(HEX) || :break},

      "%["  => lambda {parse(fmt.regex) ? dst << found : :break},
      "%*[" => lambda {parse(fmt.regex) || :break})
  end

  def test_that_it_can_scan
    engine = make_parser
    spec = "%d %2d %4d"
    result = engine.do_parse("12 34 -56", [], spec)
    assert_equal([12, 34, -56] , result)

    spec = "%i %i %i %i %i"
    result = engine.do_parse("255 0b11111111 0377 0xFF 0 ", [], spec)
    assert_equal([255, 255, 255, 255, 0] , result)

    spec = "%o %o %o"
    result = engine.do_parse("7 10 377", [], spec)
    assert_equal([7, 8, 255] , result)

    spec = "%b %b %b"
    result = engine.do_parse("10 10011 11110000", [], spec)
    assert_equal([2, 19, 240] , result)

    spec = "%x %x %x %x %x"
    result = engine.do_parse("0 F FF FFF FFFF", [], spec)
    assert_equal([0, 15, 255, 4095, 65535] , result)

    spec = "%s %*s %s"
    result = engine.do_parse("Hello Silly World", [], spec)
    assert_equal(["Hello", "World"] , result)

    spec = "%5c %*5c %5c"
    result = engine.do_parse("Hello Silly World", [], spec)
    assert_equal(["Hello", "World"] , result)

    spec = "%i %-1c"
    result = engine.do_parse("42 The secret is X", [], spec)
    assert_equal([42, "The secret is X"] , result)

    spec = "%i %-2c%c"
    result = engine.do_parse("42 The secret is X", [], spec)
    assert_equal([42, "The secret is ", "X"] , result)

    spec = "%i %*-2c%c"
    result = engine.do_parse("42 The secret is X", [], spec)
    assert_equal([42,  "X"] , result)

    spec = "%f %f %f"
    result = engine.do_parse("9.99 1.234e56 -1e100", [], spec)
    assert_equal([9.99, 1.234e56, -1e100] , result)

    spec = "%f%% %f%%"
    result = engine.do_parse("85% 75%", [], spec)
    assert_equal([85, 75] , result)

    spec = "%u %u %u"
    result = engine.do_parse("12 34 -56", [], spec)
    assert_equal([12, 34] , result)

    spec = "%r %r %r"
    result = engine.do_parse("1/2 3/4r -5/6", [], spec)
    assert_equal(['1/2'.to_r, '3/4'.to_r, '-5/6'.to_r] , result)

    spec = "%j %j %j"
    result = engine.do_parse("1+2i 3+4j -5e10-6.2i", [], spec)
    assert_equal([Complex('1+2i'), Complex('3+4j'), Complex('-5e10-6.2i')] , result)

    spec = "%q %*q %q %q"
    result = engine.do_parse("'quote' 'silly' \"un quote\" 'a \\''  ", [], spec)
    assert_equal(["quote", "un quote", "a '"] , result)
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
