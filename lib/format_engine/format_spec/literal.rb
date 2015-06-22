module FormatEngine

  # A format engine literal specification.
  class FormatLiteral

    # The literal text of this literal specification.
    attr_reader :literal

    # Set up a literal format specification.
    def initialize(literal)
      @literal = literal
    end

    # Inspect for debugging.
    def inspect
      "Literal(#{literal.inspect})"
    end

  end

end
