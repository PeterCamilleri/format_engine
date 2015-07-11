module FormatEngine

  #A format engine variable specification.
  class FormatVariable

    #The fixed part of this variable specification.
    attr_reader :format

    #The (optional) numeric format parameters or nil.
    attr_reader :parms

    #The (optional) parameter data as a string or an empty string.
    attr_reader :parm_str

    #Setup a variable format specification.
    def initialize(format)
      if format =~ /(\d+(\.\d+)?)/
        @format   = $PREMATCH + $POSTMATCH
        @parm_str = $MATCH

        if (@parm_str) =~ /\./
          @parms = [$PREMATCH, $POSTMATCH]
        else
          @parms = [@parm_str]
        end

      else
        @format   = format
        @parm_str = ""
        @parms    = nil
      end
    end

    #Is this variable supported by the engine?
    def validate(engine)
      fail "Unsupported tag = #{format.inspect}" unless engine[format]
      self
    end

    #Has a width been specified?
    def has_width?
      parms
    end

    # Get the width parameter.
    def width
      has_width? ? parms[0].to_i : 0
    end

    #Get the width as a string
    def width_str
      has_width? ? parms[0] : ""
    end

    #Has a precision been specified?
    def has_prec?
      has_width? && parms.length > 1
    end

    #Get the precision parameter.
    def prec
      has_prec? ? parms[1].to_i : 0
    end

    #Get the precision as a string
    def prec_str
      has_prec? ? parms[1] : ""
    end

    #Format onto the output string
    def do_format(spec_info)
      spec_info.fmt = self
      spec_info.instance_exec(&spec_info.engine[self.format])
    end

    #Parse from the input string
    def do_parse(spec_info)
      spec_info.fmt = self
      spec_info.instance_exec(&spec_info.engine[self.format])
    end

    #Inspect for debugging.
    def inspect
      "Variable(#{format.inspect}, #{parms.inspect})"
    end

  end

end
