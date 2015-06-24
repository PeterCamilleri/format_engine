module FormatEngine

  # The abstract base class for the Formatter and Parser classes.
  class Base

    # The data state for the formatting/parsing process.
    attr_accessor :data

    # What type of engine is this? Abstract, error
    def engine_type
      fail "Error: Cannot directly use the FormatEngine::Base class."
    end

    # Get an entry from the library
    def self.[](index)
      @lib ||= {}
      @lib[index]
    end

    # Add an entry to the library
    def self.[]=(index, value)
      @lib ||= {}
      @lib[index] = value
    end

  end

end