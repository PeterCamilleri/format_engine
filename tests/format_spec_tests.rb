require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class FormatSpecTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_it_scans_literal_formats
    test = FormatEngine::FormatSpec.get_spec "ABCDEFG!"
    assert_equal(Array, test.spec.class)
    assert_equal(1, test.spec.length)
    assert_equal(FormatEngine::FormatLiteral, test.spec[0].class)
    assert_equal("ABCDEFG!", test.spec[0].literal)
  end

  def test_that_it_scans_simple_variable_formats
    test = FormatEngine::FormatSpec.get_spec "%A"
    assert_equal(Array, test.spec.class)
    assert_equal(1, test.spec.length)
    assert_equal(FormatEngine::FormatVariable, test.spec[0].class)
    assert_equal("%A", test.spec[0].format)
    assert_equal(nil, test.spec[0].parms)
  end

  def test_that_it_scans_option_variable_formats
    "~@#&^&*-+=?_<>\\/.,|" .each_char do |char|
      test = FormatEngine::FormatSpec.get_spec "%#{char}A"
      assert_equal(Array, test.spec.class)
      assert_equal(1, test.spec.length)
      assert_equal(FormatEngine::FormatVariable, test.spec[0].class)
      assert_equal("%#{char}A", test.spec[0].format)
    end
  end

  def test_that_it_scans_single_variable_formats
    test = FormatEngine::FormatSpec.get_spec "%123A"
    assert_equal(Array, test.spec.class)
    assert_equal(1, test.spec.length)
    assert_equal(FormatEngine::FormatVariable, test.spec[0].class)
    assert_equal("%A", test.spec[0].format)

    assert_equal(Array, test.spec[0].parms.class)
    assert_equal(1, test.spec[0].parms.length)
    assert_equal("123", test.spec[0].parms[0])
  end

  def test_that_it_scans_double_variable_formats
    test = FormatEngine::FormatSpec.get_spec "%123.456A"
    assert_equal(Array, test.spec.class)
    assert_equal(1, test.spec.length)
    assert_equal(FormatEngine::FormatVariable, test.spec[0].class)
    assert_equal("%A", test.spec[0].format)

    assert_equal(Array, test.spec[0].parms.class)
    assert_equal(2, test.spec[0].parms.length)
    assert_equal("123", test.spec[0].parms[0])
    assert_equal("456", test.spec[0].parms[1])
  end

end
