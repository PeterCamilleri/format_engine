
# A mock class to test formatting
class TestPerson
  attr_reader :first_name
  attr_reader :last_name
  attr_reader :age

  def initialize(first_name, last_name, age)
    @first_name, @last_name, @age = first_name, last_name, age
  end
end
