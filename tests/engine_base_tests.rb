require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class EngineBaseTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_it_has_a_library
    test = FormatEngine::Engine.new({"%A" => 42})

    assert_equal(42, test["%A"])
    assert_equal(nil, test["%B"])
  end

end
