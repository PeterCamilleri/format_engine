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
    assert_nil(test["%B"])
    assert(test[:before])
    assert(test[:after])
    assert_equal(3, test.library.length)
  end

  def test_the_engine_cache
    lib = {
      "%A" => lambda { puts "Processing %A" },
      "%B" => lambda { puts "Processing %B" },
      "%C" => lambda { puts "Processing %C" }
    }

    spec = "%A %B %C"

    e1 = FormatEngine::Engine.new(lib)

    s1a = e1.send(:get_spec, spec)
    s1b = e1.send(:get_spec, spec)
    assert_equal(s1a, s1b)

    e2 = FormatEngine::Engine.new(lib)

    s2 = e2.send(:get_spec, spec)
    refute_equal(s1a, s2)
  end

end
