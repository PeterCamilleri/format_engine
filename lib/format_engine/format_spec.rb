#Analysis of format/parse specification strings.

require_relative 'format_spec/literal'
require_relative 'format_spec/variable'
require_relative 'format_spec/set'

module FormatEngine

  #The format string parser.
  class FormatSpec
    #The regex used to parse variable specifications.
    REGEX = %r{(?<lead>  (^|(?<=[^\\]))%){0}
               (?<flags> [~@#$^&*=?_<>|!]*){0}
               (?<var> \g<lead>\g<flags>[-+]?(\d+(\.\d+)?)?[a-zA-Z]){0}
               (?<set> \g<lead>\g<flags>(\d+(,\d+)?)?\[([^\]\\]|\\.)+\]){0}
               (?<per> \g<lead>%){0}
               \g<var> | \g<set> | \g<per>
              }x

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
        if (match_data = REGEX.match(fmt_string))
          mid = match_data.to_s
          pre = match_data.pre_match

          @specs << FormatLiteral.new(pre) unless pre.empty?
          @specs << case
                    when match_data[:var] then FormatVariable.new(mid)
                    when match_data[:set] then FormatSet.new(mid)
                    when match_data[:per] then FormatLiteral.new("\%")
                    else fail "Impossible case in scan_spec."
                    end
          fmt_string = match_data.post_match
        else
          @specs << FormatLiteral.new(fmt_string)
          fmt_string = ""
        end
      end
    end

  end
end
