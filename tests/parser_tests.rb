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
      :after  => lambda { set TestPerson.new(hsh[:f_n], hsh[:l_n]) },
      "%f"    => lambda { hsh[:f_n] = found if parse(/(\w)+/ ) },
      "%l"    => lambda { hsh[:l_n] = found if parse(/(\w)+/ ) })
  end

  def test_that_it_can_parse
    engine = make_parser
    spec = FormatEngine::FormatSpec.get_spec "%f, %l"
    result = engine.do_parse("Squidly, Jones", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)

  end
end
