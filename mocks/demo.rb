# A simple class of customer info.

require_relative '../lib/format_engine'

require_relative 'demo/demo_format'
require_relative 'demo/demo_parse'

#A demo class for the format_engine gem.
class Customer
  #Demo customer first name.
  attr_reader :first_name

  #Demo customer last name
  attr_reader :last_name

  #Demo customer age
  attr_reader :age

  #Create an instance of the demo customer.
  def initialize(first_name, last_name, age)
    @first_name, @last_name, @age = first_name, last_name, age
  end
end

if __FILE__ == $0
  cust = Customer.strprs('Jane, Smith 22', "%f, %l %a")
  puts cust.strfmt('%f %l is %a years old.')
end
