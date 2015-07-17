require_relative '../lib/format_engine'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

require_relative '../mocks/test_person_mock'

# Test the internals of the formatter engine. This is not the normal interface.
class FormatterTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def make_formatter
    FormatEngine::Engine.new(
      "%f"  => lambda {cat "%#{fmt.width_str}s" % src.first_name},
      "%F"  => lambda {cat "%#{fmt.width_str}s" % src.first_name.upcase},
      "%l"  => lambda {cat "%#{fmt.width_str}s" % src.last_name},
      "%L"  => lambda {cat "%#{fmt.width_str}s" % src.last_name.upcase})
  end

  def make_person
    TestPerson.new("Squidly", "Jones")
  end

  def make_spec(str)
    str
  end

  def make_all(str)
    [make_formatter, make_person, make_spec(str)]
  end

  def test_that_it_can_format_normally
    engine, obj, spec = make_all("Name = %f %l")
    assert_equal("Name = Squidly Jones", engine.do_format(obj, spec))
  end

  def test_that_it_can_format_shouting
    engine, obj, spec = make_all("Name = %F %L")
    assert_equal("Name = SQUIDLY JONES", engine.do_format(obj, spec))
  end

  def test_that_it_can_format_wider
    engine, obj, spec = make_all("Name = %-10f %-10l")
    assert_equal("Name = Squidly    Jones     ", engine.do_format(obj, spec))
  end

  def test_that_it_can_format_right
    engine, obj, spec = make_all("Name = %10f %10l")
    assert_equal("Name =    Squidly      Jones", engine.do_format(obj, spec))
  end

  def test_that_it_calls_before_and_after
    engine = FormatEngine::Engine.new(
      :before => lambda {dst << "((" },
      :after  => lambda {dst << "))" })

    spec = "Test"
    assert_equal("((Test))", engine.do_format(nil, spec))
  end

  def test_that_it_rejects_bad_specs
    engine, obj, spec = make_all("Name = %f %j")
    assert_raises(RuntimeError) { engine.do_format(obj, spec) }
  end

  def test_that_it_validates_before_before
    engine, obj, spec = make_all("Name = %f %j")
    test = 1
    engine[:before] = lambda { test = 2 }

    assert_raises(RuntimeError) { engine.do_format(obj, spec) }
    assert_equal(1, test)
  end

end
