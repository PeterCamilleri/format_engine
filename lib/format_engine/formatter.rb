module FormatEngine

  # The concrete class for the Formatter.
  class Formatter < Base

    # The destination string.
    attr_reader :dst

    # The source object.
    attr_reader :src

    # Set up the formatter
    def initialize(library)
      super(library)
      clear
    end

    # Clear the formatter
    def clear
      @dst = ""
      self
    end

    # Do the actual work of building the formatted output.
    #<br>Parameters
    #* src - The source object being formatted.
    #* spec - The format specification.
    def do_format(src, spec)
      @src = src
      dst << self[:before].call(src, nil).to_s
      spec.validate(self).spec.each{|fmt| fmt.do_format(self) }
      dst << self[:after].call(src, nil).to_s
    end

    # Append to the output string
    def << (str)
      @dst << str
    end
  end

end
