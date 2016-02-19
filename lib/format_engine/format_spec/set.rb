module FormatEngine

  #A format engine set specification.
  class FormatSet

    #The fixed part of this set specification.
    attr_reader :format

    #The regular expression part of this set specification.
    attr_reader :regex

    #The width parameter. Handled internally so this is always zero.
    def width
      0
    end

    #Setup a variable format specification.
    def initialize(format)
      @raw = format

      if (match_data = /(\d+,)?(\d+)(?=\[)/.match(format))
        qualifier = "{#{match_data[1] || "1,"}#{match_data[2]}}"
        @format   = match_data.pre_match + "["
        set       = match_data.post_match
      elsif format =~ /\[/
        qualifier = "+"
        @format   = $PREMATCH + $MATCH
        set       = $MATCH + $POSTMATCH
      else
        fail "Invalid set string #{format}"
      end

      @regex = Regexp.new("#{set}#{qualifier}")
    end

    #Format onto the output string
    def do_format(spec_info)
      fail "The tag %{@raw} may not be used in formatting."
    end

    #Parse from the input string
    def do_parse(spec_info)
      unless (block = spec_info.engine[format])
        fail "Unsupported tag = #{format.inspect}"
      end

      spec_info.instance_exec(&block)
    end

    #Inspect for debugging.
    def inspect
      "Set(#{@raw.inspect}, #{regex.inspect})"
    end

  end

end
