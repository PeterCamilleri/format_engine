require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class EngineBaseTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_it_has_data
    test = FormatEngine::Base.new

    assert_equal(nil, test.data)

    test.data = 5
    assert_equal(5, test.data)

    test.data = {}
    assert_equal({}, test.data)
  end

  def test_that_it_has_a_library
    test = FormatEngine::Base.new

    assert_equal(nil, test["%A"])

    test["%A"] = 42
    assert_equal(42, test["%A"])
  end

  def test_that_it_is_not_valid
    test = FormatEngine::Base.new

    assert_raises(RuntimeError) { test.validate(:fubar) }
    assert_raises(RuntimeError) { test.validate(:formatter) }
    assert_raises(RuntimeError) { test.validate(:parser) }

    assert_raises(RuntimeError) { test.engine_type }
  end

end
