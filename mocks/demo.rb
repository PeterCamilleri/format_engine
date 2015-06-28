# A simple class of customer info.

require_relative 'demo/demo_format'
require_relative 'demo/demo_parse'

#A demo class for the format_engine gem.
class Customer
  #Demo customer first name.
  attr_reader :first_name

  #Demo customer last name
  attr_reader :last_name

  #Create an instance of the demo customer.
  def initialize(first_name, last_name)
    @first_name, @last_name = first_name, last_name
  end
end
