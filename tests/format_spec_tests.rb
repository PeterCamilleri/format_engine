require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class FormatSpecTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_it_scans_literal_formats
    test = FormatEngine::FormatSpec.new "ABCDEFG!"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatLiteral, test.specs[0].class)
    assert_equal("ABCDEFG!", test.specs[0].literal)
  end

  def test_that_backslash_quotes
    test = FormatEngine::FormatSpec.new "ABC\\%DEFG!"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatLiteral, test.specs[0].class)
    assert_equal("ABC%DEFG!", test.specs[0].literal)
  end

  def test_that_it_scans_simple_variable_formats
    test = FormatEngine::FormatSpec.new "%A"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatVariable, test.specs[0].class)
    assert_equal("%A", test.specs[0].format)
    assert_equal(nil, test.specs[0].parms)
  end

  def test_that_it_scans_set_formats
    test = FormatEngine::FormatSpec.new "%[A]"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatSet, test.specs[0].class)
    assert_equal("%[", test.specs[0].short_name)
    assert_equal("%[A]", test.specs[0].long_name)
    assert_equal(/[A]+/, test.specs[0].regex)

    test = FormatEngine::FormatSpec.new "%*[A]"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatSet, test.specs[0].class)
    assert_equal("%*[", test.specs[0].short_name)
    assert_equal("%*[A]", test.specs[0].long_name)
    assert_equal(/[A]+/, test.specs[0].regex)

    test = FormatEngine::FormatSpec.new "%7[A]"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatSet, test.specs[0].class)
    assert_equal("%[", test.specs[0].short_name)
    assert_equal("%[A]", test.specs[0].long_name)
    assert_equal(/[A]{1,7}/, test.specs[0].regex)

    test = FormatEngine::FormatSpec.new "%*7[A]"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatSet, test.specs[0].class)
    assert_equal("%*[", test.specs[0].short_name)
    assert_equal("%*[A]", test.specs[0].long_name)
    assert_equal(/[A]{1,7}/, test.specs[0].regex)
  end

  def test_a_mixed_set
    test = FormatEngine::FormatSpec.new "%f %l %[age] %a"
    assert_equal(Array, test.specs.class)
    assert_equal(7, test.specs.length)

  end

  def test_that_it_scans_tab_seperators
    test = FormatEngine::FormatSpec.new "%A\t%B"
    assert_equal(Array, test.specs.class)
    assert_equal(3, test.specs.length)

    assert_equal(FormatEngine::FormatVariable, test.specs[0].class)
    assert_equal("%A", test.specs[0].format)
    assert_equal(nil, test.specs[0].parms)

    assert_equal(FormatEngine::FormatLiteral, test.specs[1].class)
    assert_equal("\t", test.specs[1].literal)

    assert_equal(FormatEngine::FormatVariable, test.specs[2].class)
    assert_equal("%B", test.specs[2].format)
    assert_equal(nil, test.specs[2].parms)
  end

  def test_that_it_scans_option_variable_formats
    "~@#&^&*-+=?_<>|".each_char do |char|
      test = FormatEngine::FormatSpec.new "%#{char}A"
      assert_equal(Array, test.specs.class)
      assert_equal(1, test.specs.length)
      assert_equal(FormatEngine::FormatVariable, test.specs[0].class)
      assert_equal("%#{char}A", test.specs[0].format)
      refute(test.specs[0].has_width?)
      refute(test.specs[0].has_prec?)
      assert_equal("", test.specs[0].width_str)
      assert_equal("", test.specs[0].prec_str)
      assert_equal("", test.specs[0].parm_str)
    end
  end

  def test_that_it_scans_single_variable_formats
    test = FormatEngine::FormatSpec.new "%123A"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatVariable, test.specs[0].class)
    assert_equal("%A", test.specs[0].format)

    assert_equal(Array, test.specs[0].parms.class)
    assert_equal(1, test.specs[0].parms.length)
    assert_equal("123", test.specs[0].parms[0])
    assert(test.specs[0].has_width?)
    refute(test.specs[0].has_prec?)
    assert_equal("123", test.specs[0].width_str)
    assert_equal("", test.specs[0].prec_str)
    assert_equal("123", test.specs[0].parm_str)
  end

  def test_that_it_scans_double_variable_formats
    test = FormatEngine::FormatSpec.new "%123.456A"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatVariable, test.specs[0].class)
    assert_equal("%A", test.specs[0].format)

    assert_equal(Array, test.specs[0].parms.class)
    assert_equal(2, test.specs[0].parms.length)
    assert_equal("123", test.specs[0].parms[0])
    assert_equal("456", test.specs[0].parms[1])
    assert(test.specs[0].has_width?)
    assert(test.specs[0].has_prec?)
    assert_equal("123", test.specs[0].width_str)
    assert_equal("456", test.specs[0].prec_str)
    assert_equal("123.456", test.specs[0].parm_str)
  end

  def test_negative_variable_formats
    test = FormatEngine::FormatSpec.new "%-123.456A"
    assert_equal(Array, test.specs.class)
    assert_equal(1, test.specs.length)
    assert_equal(FormatEngine::FormatVariable, test.specs[0].class)
    assert_equal("%A", test.specs[0].format)

    assert_equal(Array, test.specs[0].parms.class)
    assert_equal(2, test.specs[0].parms.length)
    assert_equal("-123", test.specs[0].parms[0])
    assert_equal("456", test.specs[0].parms[1])
    assert(test.specs[0].has_width?)
    assert(test.specs[0].has_prec?)
    assert_equal("-123", test.specs[0].width_str)
    assert_equal("456", test.specs[0].prec_str)
    assert_equal("-123.456", test.specs[0].parm_str)
  end

  def test_multipart_formats
    test = FormatEngine::FormatSpec.new "T(%+02A:%3B:%4.1C)"

    assert_equal(Array, test.specs.class)
    assert_equal(7, test.specs.length)

    assert_equal(FormatEngine::FormatLiteral, test.specs[0].class)
    assert_equal("T(", test.specs[0].literal)

    assert_equal(FormatEngine::FormatVariable, test.specs[1].class)
    assert_equal("%A", test.specs[1].format)
    assert_equal(1, test.specs[1].parms.length)
    assert_equal("+02", test.specs[1].parms[0])

    assert_equal(FormatEngine::FormatLiteral, test.specs[2].class)
    assert_equal(":", test.specs[2].literal)

    assert_equal(FormatEngine::FormatVariable, test.specs[3].class)
    assert_equal("%B", test.specs[3].format)
    assert_equal(1, test.specs[3].parms.length)
    assert_equal("3", test.specs[3].parms[0])

    assert_equal(FormatEngine::FormatLiteral, test.specs[4].class)
    assert_equal(":", test.specs[4].literal)

    assert_equal(FormatEngine::FormatVariable, test.specs[5].class)
    assert_equal("%C", test.specs[5].format)
    assert_equal(2, test.specs[5].parms.length)
    assert_equal("4", test.specs[5].parms[0])
    assert_equal("1", test.specs[5].parms[1])

    assert_equal(FormatEngine::FormatLiteral, test.specs[6].class)
    assert_equal(")", test.specs[6].literal)
  end

end
