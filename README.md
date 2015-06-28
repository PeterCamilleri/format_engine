# FormatEngine

The FormatEngine gem contains the common support code needed to support
string formatting and parsing routines like strftime and strptime.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'format_engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install format_engine

## Usage

```ruby
require 'format_engine'

#A demo class for the format_engine gem.
class Customer
  extend FormatEngine::AttrFormatter
  extend FormatEngine::AttrParser

  #Demo customer first name.
  attr_reader :first_name

  #Demo customer last name
  attr_reader :last_name

  attr_formatter :strfmt,
  {"%f"  => lambda {cat src.first_name.ljust(fmt.width) },
   "%l"  => lambda {cat src.last_name.ljust(fmt.width)  } }

  attr_parser :strprs,
  {"%f"    => lambda { hsh[:fn] = found if parse(/(\w)+/ ) },
   "%l"    => lambda { hsh[:ln] = found if parse(/(\w)+/ ) },
   :after  => lambda { set dst.new(hsh[:fn], hsh[:ln]) } }

  #Create an instance of the demo customer.
  def initialize(first_name, last_name)
    @first_name, @last_name = first_name, last_name
  end
end

#Then later in the code...

cust = Customer.new("Jane", "Doe")
puts cust.strfmt("%f, %l"))  #"Jane, Doe"

#And elsewhere in Gotham City...

in_str = "Jane, Doe"
agent = Customer.strprs(in_str, "%f, %l")

#Etc, etc, etc ...

```

## Philosophy

When designing this gem, a concerted effort has been applied to keeping it as
simple as possible. To this end, many subtle programming techniques have been
avoided in favor of simpler, more obvious approaches. This is based on the
observation that I don't trust code that I don't understand and I avoid code
I don't trust.

Feedback on the convenience/clarity balance as well as any other topics are
most welcomed.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/format_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
