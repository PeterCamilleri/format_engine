# A simple class of customer info.

require_relative 'demo/demo_format'
require_relative 'demo/demo_parse'

class Customer
  attr_reader :first_name
  attr_reader :last_name

  def initialize(first_name, last_name)
    @first_name, @last_name = first_name, last_name
  end
end
