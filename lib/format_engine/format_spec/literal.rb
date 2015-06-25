module FormatEngine

  # A format engine literal specification.
  class FormatLiteral

    # The literal text of this literal specification.
    attr_reader :literal

    # Set up a literal format specification.
    def initialize(literal)
      @literal = literal
    end

    # Is this literal supported by the engine? YES!
    def validate(_engine)
      self
    end

    # Format onto the output string
    def do_format(engine)
      engine << @literal
    end

    # Inspect for debugging.
    def inspect
      "Literal(#{literal.inspect})"
    end

  end

end
