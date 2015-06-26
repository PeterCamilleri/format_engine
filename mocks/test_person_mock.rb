
# A mock class to test formatting
class TestPerson
  attr_reader :first_name
  attr_reader :last_name

  def initialize(first_name, last_name)
    @first_name, @last_name = first_name, last_name
  end
end
