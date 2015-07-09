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

  #Demo defn of the strfmt method for formatted string output!
  attr_formatter :strfmt,
  {"%f"  => lambda {cat src.first_name.ljust(fmt.width) },
   "%l"  => lambda {cat src.last_name.ljust(fmt.width)  } }

  #Demo defn of the strprs method for formatted string input!
  attr_parser :strprs,
  {"%f"    => lambda { tmp[:fn] = found if parse(/(\w)+/ ) },
   "%l"    => lambda { tmp[:ln] = found if parse(/(\w)+/ ) },
   :after  => lambda { set dst.new(tmp[:fn], tmp[:ln]) } }

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
## Format Specification

Format String Specification Syntax (BNF):

* spec = ( text | item )+
* item = "%" flag* (parm ("." parm)?)? command
* flag = ( "~" | "@" | "#" | "&" | "^"  |
  "&" | "*" | "-" | "+" | "="  |
  "?" | "_" | "<" | ">" | "\\" |
  "/" | "." | "," | "|" | "!"  )
* parm = ("0" .. "9")+
* command = ("a" .. "z" | "A" .. "Z")


###Samples:

The format specification:
```ruby
"Elapsed = %*02H:%M:%5.2S!"
```
creates the following format specification array:

```ruby
[Literal("Elapsed = "),
 Variable("%*H", ["02"]),
 Literal(":"),
 Variable("%M", nil).
 Literal(":"),
 Variable("%S", ["5", "2"]),
 Literal("!")]
```
Where literals are processed as themselves and variables are executed by looking
up the format string in the library and executing the corresponding block.

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
The format specifier (accessed as fmt above) has the following attributes:
* width - The width parameter or 0 if not specified.
* prec - The precision parameter or 0 if not specified.

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

1. Fork it ( https://github.com/[my-github-username]/format_engine/fork )
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


