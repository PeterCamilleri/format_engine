require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

require_relative '../mocks/test_person_mock'

# Test the internals of the parser engine. This is not the normal interface.
class ParserTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def make_parser
    FormatEngine::Engine.new(
      "%f"    => lambda { tmp[:fn] = found if parse(/(\w)+/ ) },
      "%F"    => lambda { tmp[:fn] = found.upcase if parse(/(\w)+/) },
      "%-F"   => lambda { tmp[:fn] = found.capitalize if parse(/(\w)+/) },
      "%l"    => lambda { tmp[:ln] = found if parse(/(\w)+/ ) },
      "%L"    => lambda { tmp[:ln] = found.upcase if parse(/(\w)+/) },
      "%-L"   => lambda { tmp[:ln] = found.capitalize if parse(/(\w)+/) },
      "%s"    => lambda { parse(/\s+/) },
      "%,s"   => lambda { parse(/[,\s]\s*/) },
      "%t"    => lambda { parse("\t") },
      "%!t"   => lambda { parse!("\t") },

      :after  => lambda { set TestPerson.new(tmp[:fn], tmp[:ln]) })
  end

  def test_that_it_can_parse
    engine = make_parser
    spec = "%f, %l"
    result = engine.do_parse("Squidly, Jones", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
  end

  def test_that_it_can_parse_loudly
    engine = make_parser
    spec =  "%F, %L"
    result = engine.do_parse("Squidly, Jones", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("SQUIDLY", result.first_name)
    assert_equal("JONES", result.last_name)
  end

  def test_that_it_can_fix_shouting
    engine = make_parser
    spec =  "%-F, %-L"
    result = engine.do_parse("SQUIDLY, JONES", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
  end

  def test_that_it_can_flex_parse
    engine = make_parser
    spec =  "%f%,s%l"
    result = engine.do_parse("Squidly, Jones", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
  end

  def test_that_it_can_tab_parse
    engine = make_parser
    spec =  "%f%t%l"
    result = engine.do_parse("Squidly\tJones", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
  end

  def test_that_it_can_detect_errors
    engine = make_parser
    spec =  "%f, %l"

    assert_raises(RuntimeError) do
      engine.do_parse("Squidly Jones", TestPerson, spec)
    end

    spec =  "%f%!t%l"

    assert_raises(RuntimeError) do
      engine.do_parse("Squidly Jones", TestPerson, spec)
    end
  end

end
