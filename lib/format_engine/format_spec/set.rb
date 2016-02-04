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

      if format =~ /(\d+)(?=\[)/
        qualifier = "{1,#{$MATCH}}"
        @format   = $PREMATCH + "["
        set       = $POSTMATCH
      elsif format =~ /\[/
        qualifier = "+"
        @format   = $PREMATCH + $MATCH
        set       = $MATCH + $POSTMATCH
      else
        fail "Invalid set string #{format}"
      end

      @regex = Regexp.new("#{set}#{qualifier}")
    end

    #Is this variable supported by the engine?
    def validate(engine)
      fail "Unsupported tag = #{format.inspect}" unless engine[format]
      self
    end

    #Format onto the output string
    def do_format(spec_info)
      fail "The tag %{@raw} may not be used in formatting."
    end

    #Parse from the input string
    def do_parse(spec_info)
      spec_info.fmt = self
      spec_info.instance_exec(&spec_info.engine[self.format])
    end

    #Inspect for debugging.
    def inspect
      "Set(#{format.inspect}, #{regex.inspect})"
    end

  end

end
