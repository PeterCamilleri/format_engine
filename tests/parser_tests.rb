require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

require_relative '../mocks/test_person_mock'

class ParserTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def make_parser
    FormatEngine::Parser.new(
      "%f"  => lambda { },
      "%l"  => lambda { })
  end

  def test_that_it_can_parse
    engine = make_parser
  end
end