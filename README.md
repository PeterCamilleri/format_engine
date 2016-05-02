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

In general the format engine allows for the easy creation of formatters and
parsers. This is done using the attr_formatter and attr_parser methods that
work in a manner analogous to attr_reader etc for creating access to instance
data.

#### attr_formatter

Creates a data formatting facility for the specified class.

_Prerequisites_
<br>The class must 'extend FormatEngine::AttrFormatter'

_Arguments_
* method_symbol - the name of the formatter instance method created by this
method
* library - a hash mapping specifications to actions (lambda blocks)

_Returns_
<br>The formatting engine created for the formatter.

_The created instance method_
<br>This method creates an instance method that provides formatted text from
an object. This takes the form:

    an_object.method_name(format_string) -> a_formatted_string

#### attr_parse

Creates a data parsing facility for the specified class.

_Prerequisites_
<br>The class must 'extend FormatEngine::AttrParser'

_Arguments_
* method_symbol - the name of the parser class method created by this method.
* library - a hash mapping specifications to actions (lambda blocks)

_Returns_
<br>The formatting engine created for the parser.

_The created class method_
<br>This method creates an class method that parses formatted text into a new
instance of the class. This takes the form:

    AClass.method_name(input_string, format_string) -> an_object

_Extras_
<br>After the parsing method is completed, the unparsed attribute of the parser
engine contains the un-processed portion of the input string. If no parsing
has been performed, this is an empty string.

#### Special entries
The library has two special entries keyed by symbols instead of strings.
These are

* :before - references a block that is executed before the formatting or
parsing process starts.
* :after - references a block that is executed after the formatting or
parsing process finishes.

By default, both of these entries take no action.

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
  {"%a" => lambda {cat "%#{fmt.width_str}d" % src.age },
   "%f" => lambda {cat "%#{fmt.width_str}s" % src.first_name },
   "%l" => lambda {cat "%#{fmt.width_str}s" % src.last_name  }
  }

  #Demo defn of the strprs method for formatted string input!
  attr_parser :strprs,
  {"%a"   => lambda { tmp[:age] = found.to_i if parse(/(\d)+/ ) },
   "%f"   => lambda { tmp[:fn] = found if parse(/(\w)+/ ) },
   "%l"   => lambda { tmp[:ln] = found if parse(/(\w)+/ ) },
   :after => lambda { set dst.new(tmp[:fn], tmp[:ln], tmp[:age]) }
  }

  #Create an instance of the demo customer.
  def initialize(first_name, last_name, age)
    @first_name, @last_name, @age = first_name, last_name, age
  end
end

#Then later in the code...

cust = Customer.strprs('Jane, Smith 22', "%f, %l %a")

# and in another part of Gotham City...

puts cust.strfmt('%f %l is %a years old.')

# Prints out: Jane Smith is 22 years old.

#Etc, etc, etc ...

```

## In the wild...

An example of the format_engine in action is the ruby_sscanf
gem (https://github.com/PeterCamilleri/ruby_sscanf) where it is used to
provide a facility for parsing strings and extracting data along with a
generous helping of performance enhancement.

## Format Specification

Format String Specification Syntax (Regex):

The parsing of format specification strings is based on the following regular
expression. This expression is applied repeatedly until all the specifications
have been extracted from the input string.

    PARSE_REGEX =
      %r{(?<lead>  (^|(?<=[^\\]))%){0}
         (?<flags> [~@#$^&*=?_<>|!]*){0}

         (?<var> \g<lead>\g<flags>[-+]?(\d+(\.\d+)?)?[a-zA-Z]){0}
         (?<set> \g<lead>\g<flags>(\d+(,\d+)?)?\[([^\]\\]|\\.)+\]){0}
         (?<rgx> \g<lead>\g<flags>\/([^\\ \/]|\\.)*\/([imx]*)){0}
         (?<per> \g<lead>%){0}

         \g<var> | \g<set> | \g<rgx> | \g<per>
        }x

### Var
A format specification of the classical form:

    %[flags][+/-][width[.precision]]letter

### Set
A regular expression set (or un-set), used for parsing only, of the form:

    %[flags][[min_width,]max_width]"["[^]set_chars"]"

### Rgx
A full blown regular expression, used for parsing only, of the form:

    %[flags]/regex stuff goes here/[options]

Supported options are i, m, and x.

### Per
A %% which evaluates to a literal character %. This is the old school
alternative to \\% which is preferred.

### Literal
Text in between the various format specifications is treated as literal text.

###Format Internals:

The format specification:
```ruby
"Elapsed = %*02H:%M:%-5.2S %d%% %@1[!?] %/a+b+c+/i"
```
creates the following format specification array:

```ruby
#<FormatEngine::FormatSpec:0x1be2140
 @specs=
  [Literal("Elapsed = "),
   Variable("%*H", ["02"]),
   Literal(":"),
   Variable("%M", nil),
   Literal(":"),
   Variable("%S", ["-5", "2"]),
   Literal(" "),
   Variable("%d", nil),
   Literal("%"),
   Literal(" "),
   Set("%@[!?]", "%@[", /[!?]{1,1}/),
   Literal(" "),
   Regex("%/a+b+c+/i", "%/", /a+b+c+/i)]>
```
Where literals are processed as themselves, except:
* If that literal ends with a space, that space will parse zero or more spaces.
When formatting, the trailing space is just another space.
* A %% will be treated as a single % sign.
* A backslash character will take the character that follows as a literal
character. Thus \\% is equivalent to %%.

Variables are executed by looking up the format string (without the width or
precision fields) in the library and executing the corresponding block. The
format string can be seen in the above sample as the first string in the
Variable

Sets and Regexes work by looking into the input string with their regular
expression. Both are only ever used when parsing, never for formatting.
They are executed by first looking up their long name, listed first, and
then if the long name is not found, their short name, listed second is tried.

**Note:** If a format specification does not correspond to an entry in the
library, an exception occurs. For example

    RuntimeError detected: Unsupported tag = "%!!!d"

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
* grab - Grab some text based on the width of the format.
* found? - Did the last parse succeed?
* found - The text found by the last parse (or parse!) operation.

###Variable Format Specifier Attributes
The format specifier, used in both formatting and parsing and accessed as the
fmt attribute, has itself, the following attributes:
* has_width? - Was a width specified?
* width - The width parameter or 0 if not specified.
* width_str - The actual width text or an empty string.
* has_prec? - Was a precision specified?
* prec - The precision parameter or 0 if not specified.
* prec_str - The actual precision text or an empty string.
* parm_str - The actual parameter (width and precision) text or an empty string.

###Set and Regex Format Specifier Attributes
* width - Always 0.
* regex - The internal regex compiled for this specification

## Contributing

#### Plan A

1. Fork it ( https://github.com/PeterCamilleri/format_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

#### Plan B

Go to the GitHub repository and raise an issue calling attention to some
aspect that could use some TLC or a suggestion or idea.
