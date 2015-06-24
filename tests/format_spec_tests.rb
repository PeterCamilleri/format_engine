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
    "~@#&^&*-+=?_<>\\/.,|".each_char do |char|
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

  def test_multipart_formats
    test = FormatEngine::FormatSpec.get_spec "T(%+02A:%3B:%4.1C)"

    assert_equal(Array, test.spec.class)
    assert_equal(7, test.spec.length)

    assert_equal(FormatEngine::FormatLiteral, test.spec[0].class)
    assert_equal("T(", test.spec[0].literal)

    assert_equal(FormatEngine::FormatVariable, test.spec[1].class)
    assert_equal("%+A", test.spec[1].format)
    assert_equal(1, test.spec[1].parms.length)
    assert_equal("02", test.spec[1].parms[0])

    assert_equal(FormatEngine::FormatLiteral, test.spec[2].class)
    assert_equal(":", test.spec[2].literal)

    assert_equal(FormatEngine::FormatVariable, test.spec[3].class)
    assert_equal("%B", test.spec[3].format)
    assert_equal(1, test.spec[3].parms.length)
    assert_equal("3", test.spec[3].parms[0])

    assert_equal(FormatEngine::FormatLiteral, test.spec[4].class)
    assert_equal(":", test.spec[4].literal)

    assert_equal(FormatEngine::FormatVariable, test.spec[5].class)
    assert_equal("%C", test.spec[5].format)
    assert_equal(2, test.spec[5].parms.length)
    assert_equal("4", test.spec[5].parms[0])
    assert_equal("1", test.spec[5].parms[1])

    assert_equal(FormatEngine::FormatLiteral, test.spec[6].class)
    assert_equal(")", test.spec[6].literal)
  end

  def test_that_it_validates
    engine = { "%A" => true, "%B" => true }

    test = FormatEngine::FormatSpec.get_spec "%A and %B"
    assert_equal(test, test.validate(engine))

    test = FormatEngine::FormatSpec.get_spec "%A and %C"
    assert_raises(RuntimeError) { test.validate(engine) }
  end

  def test_that_it_caches
    t1 = FormatEngine::FormatSpec.get_spec "%123.456A"
    t2 = FormatEngine::FormatSpec.get_spec "%123.456A"
    assert(t1.object_id == t2.object_id)

    t3 = FormatEngine::FormatSpec.get_spec "%123.457A"
    assert(t1.object_id != t3.object_id)

    t4 = FormatEngine::FormatSpec.get_spec "%123.457A"
    assert(t4.object_id == t3.object_id)
  end

end
