module FormatEngine

  # The abstract base class for the Formatter and Parser classes.
  class Base

    #Set up base data structures.
    def initialize(library)
      @lib = library

      #Set up defaults for pre and post amble blocks.
      nop = lambda { }

      @lib[:before] ||= nop
      @lib[:after]  ||= nop
    end

    # Get an entry from the library
    def [](index)
      @lib[index]
    end

  end

end
