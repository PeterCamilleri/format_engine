module FormatEngine

  # The engine class of the format engine.
  class Engine

    #The parse library
    attr_reader :library

    #Set up base data structures.
    def initialize(library)
      @library = library

      #Set up defaults for pre and post amble blocks.
      nop = lambda { }
      @library[:before] ||= nop
      @library[:after]  ||= nop
    end

    # Get an entry from the library
    def [](index)
      @library[index]
    end

    # Set an entry in the library
    def []=(index, value)
      @library[index] = value
    end

    #Do the actual work of building the formatted output.
    #<br>Parameters
    #* src - The source object being formatted.
    #* format_spec_str - The format specification string.
    def do_format(src, format_spec_str)
      spec_info = SpecInfo.new(src, "", self, {})

      due_process(spec_info, format_spec_str) do |fmt|
        fmt.do_format(spec_info)
      end
    end

    #Do the actual work of parsing the formatted input.
    #<br>Parameters
    #* src - The source string being parsed.
    #* dst - The class of the object being created.
    #* parse_spec_str - The format specification string.
    def do_parse(src, dst, parse_spec_str)
      spec_info = SpecInfo.new(src, dst, self, {})

      due_process(spec_info, parse_spec_str) do |fmt|
        fmt.do_parse(spec_info)
      end
    end

    #Do the actual work of parsing the formatted input.
    #<br>Parameters
    #* spec_info - The state of the process.
    #* spec_str - The format specification string.
    #* block - A code block performed for each format specification.
    def due_process(spec_info, spec_str, &block)
      spec = FormatSpec.get_spec(spec_str).validate(self)

      spec_info.instance_exec(&self[:before])
      spec.specs.each(&block)
      spec_info.instance_exec(&self[:after])

      spec_info.dst
    end

  end
end
