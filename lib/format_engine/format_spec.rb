require_relative 'format_spec/literal'
require_relative 'format_spec/variable'

# Format String Specification Syntax (BNF):
#  spec = (text | item)+
#  item = "%" flag* (parm ("." parm)? )? command
#  flag = ( "~" | "@" | "#" | "&" | "^"  |
#           "&" | "*" | "-" | "+" | "="  |
#           "?" | "_" | "<" | ">" | "\\" |
#           "/" | "." | "," | "|" | "!"  )
#  parm = ("0" .. "9" )+
#  command = ("a" .. "z" | "A" .. "Z")
#
#  Sample: x = FormatSpec.get_spec "Elapsed = %*3.1H:%02M!"

module FormatEngine

  #The format string parser.
  class FormatSpec
    #Don't use new, use get_spec instead.
    private_class_method :new

    #Either get a format specification from the pool or create one.
    def self.get_spec(fmt_string)
      @spec_pool ||= {}
      @spec_pool[fmt_string] ||= new(fmt_string)
    end

    #The array of specifications that were extracted.
    attr_reader :specs

    #Set up an instance of a format specification.
    #<br>Note
    #This is a private method (rdoc gets it wrong). To create new instances of
    #\FormatSpec do not use \FormatSpec.new, but use \FormatSpec.get_spec instead.
    def initialize(fmt_string)
      @specs = []
      scan_spec(fmt_string)
    end

    #Scan the format string extracting literals and variables.
    def scan_spec(fmt_string)
      until fmt_string.empty?
        if fmt_string =~ /%[~@#$^&*\=?_<>\\\/\.,\|!]*[-+]?(\d+(\.\d+)?)?[a-zA-Z]/
          @specs << FormatLiteral.new($PREMATCH) unless $PREMATCH.empty?
          @specs << FormatVariable.new($MATCH)
          fmt_string  =  $POSTMATCH
        else
          @specs << FormatLiteral.new(fmt_string)
          fmt_string = ""
        end
      end
    end

    #Validate the specs of this format against the engine.
    def validate(engine)
      specs.each {|item| item.validate(engine)}
      self
    end

  end
end
