module FormatEngine

  # A format engine literal specification.
  class FormatLiteral

    # The literal text of this literal specification.
    attr_reader :literal

    # Set up a literal format specification.
    def initialize(literal)
      @literal  = literal
      @head     = literal.rstrip
      @has_tail = @head != @literal
    end

    #The width parameter. Handled literally so this is always zero.
    def width
      0
    end

    # Is this literal supported by the engine? YES!
    def validate(_engine)
      self
    end

    # Format onto the output string
    def do_format(spec_info)
      spec_info.dst << @literal
    end

    # Parse from the input string
    def do_parse(spec_info)
      spec_info.parse!(@head) unless @head.empty?
      spec_info.parse(/\s*/)  if     @has_tail
    end

    # Inspect for debugging.
    def inspect
      "Literal(#{literal.inspect})"
    end

  end

end
