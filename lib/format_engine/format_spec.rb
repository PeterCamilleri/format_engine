#Analysis of format/parse specification strings.

require_relative 'format_spec/parse_regex'
require_relative 'format_spec/literal'
require_relative 'format_spec/variable'
require_relative 'format_spec/set'
require_relative 'format_spec/rgx'

module FormatEngine

  #The format string parser.
  class FormatSpec

    #The array of specifications that were extracted.
    attr_reader :specs

    #Set up an instance of a format specification.
    def initialize(fmt_string)
      @specs = []
      scan_spec(fmt_string)
    end

    # Validate the specs of this format against the engine.
    def validate(engine)
      specs.each {|item| item.validate(engine)}
      self
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
                    when match_data[:rgx] then FormatRgx.new(mid)
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
