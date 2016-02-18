require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

require_relative '../mocks/test_person_mock'

# Test the internals of the parser engine. This is not the normal interface.
class ParserTester < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def make_parser
    FormatEngine::Engine.new(
      "%a"    => lambda { tmp[:age] = found.to_i if parse(/\d+/) },
      "%f"    => lambda { tmp[:fn] = found if parse(/(\w)+/) },
      "%F"    => lambda { tmp[:fn] = found.upcase if parse(/(\w)+/) },
      "%-F"   => lambda { tmp[:fn] = found.capitalize if parse(/(\w)+/) },
      "%l"    => lambda { tmp[:ln] = found if parse(/(\w)+/ ) },
      "%L"    => lambda { tmp[:ln] = found.upcase if parse(/(\w)+/) },
      "%-L"   => lambda { tmp[:ln] = found.capitalize if parse(/(\w)+/) },
      "%["    => lambda { parse! fmt.regex },
      "%t"    => lambda { parse("\t") },
      "%!t"   => lambda { parse!("\t") },

      :after  => lambda do
        set dst.new(*[tmp[:fn], tmp[:ln], tmp[:age]].delete_if(&:nil?))
      end)
  end

  def test_that_it_can_parse
    engine = make_parser
    spec = "%f, %l %a"
    result = engine.do_parse("Squidly, Jones 55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
  end

  def test_that_it_can_parse_loudly
    engine = make_parser
    spec =  "%F, %L %a"
    result = engine.do_parse("Squidly, Jones 55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("SQUIDLY", result.first_name)
    assert_equal("JONES", result.last_name)
  end

  def test_that_it_can_fix_shouting
    engine = make_parser
    spec =  "%-F, %-L %a"
    result = engine.do_parse("SQUIDLY, JONES 55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
  end

  def test_that_it_can_flex_parse
    engine = make_parser
    spec =  "%f, %l, %a"

    #No spaces.
    result = engine.do_parse("Squidly,Jones,55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)

    #One space.
    result = engine.do_parse("Squidly, Jones, 55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)

    #Two spaces.
    result = engine.do_parse("Squidly,  Jones,  55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
  end

  def test_that_it_can_tab_parse
    engine = make_parser
    spec =  "%f %l %a"
    result = engine.do_parse("Squidly\tJones\t55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
    assert_equal(55, result.age)
  end

  def test_that_it_can_parse_sets
    engine = make_parser
    spec =  "%f %l %[age] %a"
    result = engine.do_parse("Squidly Jones age 55", TestPerson, spec)

    assert_equal(TestPerson, result.class)
    assert_equal("Squidly", result.first_name)
    assert_equal("Jones", result.last_name)
    assert_equal(55, result.age)
  end

  def test_that_it_can_detect_errors
    engine = make_parser
    spec =  "%f, %l %a"

    assert_raises(RuntimeError) do
      engine.do_parse("Squidly Jones 55", TestPerson, spec)
    end

    spec =  "%f%!t%l %a"

    assert_raises(RuntimeError) do
      engine.do_parse("Squidly Jones 55", TestPerson, spec)
    end

    spec =  "%f %l"

    assert_raises(ArgumentError) do
      engine.do_parse("Squidly Jones 55", TestPerson, spec)
    end

    spec =  "%f %l %a"

    assert_raises(ArgumentError) do
      engine.do_parse("Squidly Jones", TestPerson, spec)
    end

  end

end
