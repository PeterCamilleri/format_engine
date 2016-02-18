require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class LiteralSpecTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_it_formats
    spec_info = FormatEngine::SpecInfo.new(nil, "", nil)
    test = FormatEngine::FormatLiteral.new("Test 1 2 3")
    test.do_format(spec_info)

    assert_equal("Test 1 2 3", spec_info.dst)
  end
end
