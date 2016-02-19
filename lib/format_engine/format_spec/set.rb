module FormatEngine

  #A format engine set specification.
  class FormatSet

    #The full name of the set.
    attr_reader :long_name

    #The short form name of the set.
    attr_reader :short_name

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
        qualifier   = "{#{match_data[1] || "1,"}#{match_data[2]}}"
        @short_name = match_data.pre_match + "["
        @long_name  = match_data.pre_match + match_data.post_match
        set         = match_data.post_match
      elsif format =~ /\[/
        qualifier   = "+"
        @short_name = $PREMATCH + $MATCH
        @long_name  = format
        set         = $MATCH + $POSTMATCH
      else
        fail "Invalid set string #{format}"
      end

      @regex = Regexp.new("#{set}#{qualifier}")
    end

    #Is this format item supported by the engine's library?
    def validate(engine)
      @block = engine[@long_name] || engine[@short_name]
      fail "Unsupported tag = #{@raw.inspect}" unless @block
      true
    end

    #Format onto the output string
    def do_format(spec_info)
      fail "The tag %{@raw} may not be used in formatting."
    end

    #Parse from the input string
    def do_parse(spec_info)
      spec_info.instance_exec(&@block)
    end

    #Inspect for debugging.
    def inspect
      "Set(#{@long_name.inspect}, #{@short_name.inspect}, #{regex.inspect})"
    end

  end

end
