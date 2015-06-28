module FormatEngine

  # The engine class of the format engine.
  class Engine

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

    # Do the actual work of building the formatted output.
    #<br>Parameters
    #* src - The source object being formatted.
    #* format_spec - The format specification.
    def do_format(src, dst, format_spec)
      spec_info = SpecInfo.new(src, dst, nil, self, {})

      spec_info.instance_exec(&self[:before])

      format_spec.validate(self).specs.each do |fmt|
        fmt.do_format(spec_info)
      end

      spec_info.instance_exec(&self[:after])

      spec_info.dst
    end

    # Do the actual work of parsing the formatted input.
    #<br>Parameters
    #* src - The source string being parsed.
    #* format_spec - The format specification.
    def do_parse(src, dst, format_spec)
      spec_info = SpecInfo.new(src, dst, nil, self, {})

      spec_info.instance_exec(&self[:before])

      format_spec.validate(self).specs.each do |fmt|
        fmt.do_parse(spec_info)
      end

      spec_info.instance_exec(&self[:after])

      spec_info.dst
    end

  end

end
