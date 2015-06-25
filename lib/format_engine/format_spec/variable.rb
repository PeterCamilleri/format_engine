module FormatEngine

  # A format engine variable specification.
  class FormatVariable

    # The fixed part of this variable specification.
    attr_reader :format

    # The (optional) numeric format parameters.
    attr_reader :parms

    # Setup a variable format specification.
    def initialize(format)
      if format =~ /(\d+(\.\d+)?)/
        @format = $PREMATCH + $POSTMATCH

        if (digits = $MATCH) =~ /\./
          @parms = [$PREMATCH, $POSTMATCH]
        else
          @parms = [digits]
        end

      else
        @parms  = nil
        @format = format
      end
    end

    # Is this variable supported by the engine?
    def validate(engine)
      fail "Unsupported tag = #{format.inspect}" unless engine[format]
      self
    end

    # Get the width parameter.
    def width
      parms ? parms[0].to_i : 0
    end

    # Get the precision parameter.
    def prec
      (parms && parms.length > 1) ? parms[1].to_i : 0
    end

    # Format onto the output string
    def do_format(engine)
      engine << engine[self.format].call(engine.src, self)
    end

    # Inspect for debugging.
    def inspect
      "Variable(#{format.inspect}, #{parms.inspect})"
    end

  end

end