require_relative 'format_spec/literal'
require_relative 'format_spec/variable'

# Format String Specification Syntax (BNF):
# spec = { text | item }+
# item = "%" {flag}* {parm {"." parm}?}? {command}
# flag = { "~" | "@" | "#" | "&" | "^"  |
#          "&" | "*" | "-" | "+" | "="  |
#          "?" | "_" | "<" | ">" | "\\" |
#          "/" | "." | "," | "|" }
# parm = { "0" .. "9" }+
# command = { "a" .. "z" | "A" .. "Z" }
# Sample: x = FormatSpec.get_spec "Elapsed = %*03.1H:%M:%S!"

module FormatEngine

  #The format string parser.
  class FormatSpec
    # Don't use new, use get_spec instead.
    private_class_method :new

    # Either get a format specification from the pool or create one.
    def self.get_spec(fmt_string)
      @spec_pool ||= {}
      @spec_pool[fmt_string] ||= new(fmt_string)
    end

    # The array of specifications that were extracted.
    attr_reader :spec

    # Set up an instance of a format specification
    def initialize(fmt_string)
      @spec = []
      scan_spec(fmt_string, @spec)
    end

    # Scan the format string extracting literals and variables.
    #<br>Endemic Code Smells
    #* :reek:UtilityFunction  :reek:FeatureEnvy
    def scan_spec(fmt_string, spec_array)
      until fmt_string.empty?
        if fmt_string =~ /%[~@#$^&*\-+=?_<>\\\/\.,\|]*(\d+(\.\d+)?)?[a-zA-Z]/
          spec_array << FormatLiteral.new($PREMATCH) unless $PREMATCH.empty?
          spec_array << FormatVariable.new($MATCH)
          fmt_string  =  $POSTMATCH
        else
          spec_array << FormatLiteral.new(fmt_string)
          fmt_string = ""
        end
      end
    end

    # Validate the specs of this format against the engine.
    def validate(engine)
      spec.each {|item| item.validate(engine)}
      self
    end

  end
end
