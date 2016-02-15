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

In general formatters and parsers are defined using the attr_formatter
and attr_parser methods. Both of these methods accept a symbol and a hash of
strings (plus a few special symbols) that point to blocks (that take no arguments).

The symbol is the name of a method that is created. The hash forms a library
of supported formats. Special hash keys are the symbols :before (that is run
before all other operations) and :after (that is run after all other operations)

### Example
The following example is found in the mocks folder:

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

  #Demo customer age
  attr_reader :age

  #Demo defn of the strfmt method for formatted string output!
  attr_formatter :strfmt,
  {"%a"  => lambda {cat "%#{fmt.width_str}d" % src.age },
   "%f"  => lambda {cat "%#{fmt.width_str}s" % src.first_name },
   "%l"  => lambda {cat "%#{fmt.width_str}s" % src.last_name  }
  }

  #Demo defn of the strprs method for formatted string input!
  attr_parser :strprs,
  {"%a"    => lambda { tmp[:age] = found.to_i if parse(/(\d)+/ ) },
   "%f"    => lambda { tmp[:fn] = found if parse(/(\w)+/ ) },
   "%l"    => lambda { tmp[:ln] = found if parse(/(\w)+/ ) },
   :after  => lambda { set dst.new(tmp[:fn], tmp[:ln], tmp[:age]) }
  }

  #Create an instance of the demo customer.
  def initialize(first_name, last_name, age)
    @first_name, @last_name, @age = first_name, last_name, age
  end
end

#Then later in the code...

cust = Customer.strprs('Jane, Smith 22', "%f, %l %a")

# snd still in another part of Gotham City...

puts cust.strfmt('%f %l is %a years old.')

# Prints out: Jane Smith is 22 years old.

#Etc, etc, etc ...

```
## Format Specification

Format String Specification Syntax (Regex):

    REGEX = %r{(?<lead>  (^|(?<=[^\\]))%){0}
               (?<flags> [~@#$^&*\=?_<>|!]*){0}
               (?<parms> [-+]?(\d+(\.\d+)?)?){0}
               (?<var> \g<lead>\g<flags>\g<parms>[a-zA-Z]){0}
               (?<set> \g<lead>\g<flags>\d*\[([^\]\\]|\\.)+\]){0}
               (?<per> \g<lead>%){0}
               \g<var> | \g<set> | \g<per>
              }x

###Samples:

The format specification:
```ruby
"Elapsed = %*02H:%M:%-5.2S!"
```
creates the following format specification array:

```ruby
[Literal("Elapsed = "),
 Variable("%*H", ["02"]),
 Literal(":"),
 Variable("%M", nil).
 Literal(":"),
 Variable("%S", ["-5", "2"]),
 Literal("!")]
```
Where literals are processed as themselves, except:
* If that literal ends with a space, that space will parse zero or more spaces.
When formatting, the trailing space is just another space.
* A %% will be treated as a single % sign.
* A backslash character will take the character that follows as a literal
character. Thus \\% is equivalent to %%.

Variables are executed by looking up the format string (without the width or
precision fields) in the library and executing the corresponding block.

**Note:** If a format string does not correspond to an entry in the library,
an exception occurs.

## Formatting / Parsing Blocks

In the context of a formatting / parsing block, the
"self" of that block is an instance of SpecInfo. The
components of that object are:

###When Formatting:
Attributes:
* src - The object that is the source of the data (RO).
* dst - A string that receives the formatted output (RO).
* fmt - The format specification currently being processed (RW).
* engine - The formatting engine. Mostly for access to the library (RO).
* tmp - A utility hash so that the formatting process can retain state (RO).

Methods
* cat - Append the string that follows to the formatted output. This is
  equivalent to the code dst << "string"

###When Parsing:
Attributes:
* src - A string that is the source of formatted input (RO).
* dst - The class of the object being created (RO).
* fmt - The parse specification currently being processed (RW).
* engine - The parsing engine. Mostly for access to the library (RO).
* tmp - A utility hash so that the parsing process can retain state (RO).

Methods
* set - Set the return value of the parsing operation to the value that follows.
* parse - Look for the string or regex parm that follows. Return the data found or nil.
* parse! - Like parse but raises an exception (with optional msg) if not found.
* found? - Did the last parse succeed?
* found - The text found by the last parse (or parse!) operation.

###Format Specifier Attributes
The format specifier, used in both formatting and parsing and accessed as the
fmt attribute, has itself, the following attributes:
* has_width? - Was a width specified?
* width - The width parameter or 0 if not specified.
* width_str - The actual width text or an empty string.
* has_prec? - Was a precision specified?
* prec - The precision parameter or 0 if not specified.
* prec_str - The actual precision text or an empty string.
* parm_str - The actual parameter (width and precision) text or an empty string.

## Philosophy

When designing this gem, a concerted effort has been applied to keeping it as
simple as possible. To this end, many subtle programming techniques have been
avoided in favor of simpler, more obvious approaches. This is based on the
observation that I don't trust code that I don't understand and I avoid code
that I don't trust.

Feedback on the convenience/clarity balance as well as any other topics are
most welcomed.

## Contributing

#### Plan A

1. Fork it ( https://github.com/PeterCamilleri/format_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

#### Plan B

Go to the GitHub repository and raise an issue calling attention to some
aspect that could use some TLC or a suggestion or idea. Apply labels to
the issue that match the point you are trying to make. Then follow your
issue and keep up-to-date as it is worked on. Or not as pleases you.
All input are greatly appreciated.


