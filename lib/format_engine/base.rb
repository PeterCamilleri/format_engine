module FormatEngine

  # The abstract base class for the Formatter and Parser classes.
  class Base

    # The data state for the formatting/parsing process.
    attr_accessor :data

    # Is this the correct engine type?
    def validate(engine_type)
      fail "Error: Invalid Engine Type" unless engine_type == self.engine_type
      true
    end

    # What type of engine is this? Abstract, error
    def engine_type
      fail "Error: Cannot directly use the abstract Base engine."
    end

    # Get an entry from the library
    def [](index)
      @lib ||= {}
      @lib[index]
    end

    # Add an entry to the library
    def []=(index, value)
      @lib ||= {}
      @lib[index] = value
    end

  end

end