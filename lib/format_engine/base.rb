module FormatEngine

  # The abstract base class for the Formatter and Parser classes.
  class Base

    # The data state for the formatting/parsing process.
    attr_accessor :data

    #Set up base data structures.
    def initialize(library)
      @lib = library

      #Set up defaults for pre and post amble blocks.
      @lib[:before] ||= lambda {|*_args| }
      @lib[:after]  ||= lambda {|*_args| }
    end

    # Get an entry from the library
    def [](index)
      @lib[index]
    end

  end

end
