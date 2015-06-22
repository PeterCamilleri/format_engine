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

    # Inspect for debugging.
    def inspect
      "Variable(#{format.inspect}, #{parms.inspect})"
    end

  end

end