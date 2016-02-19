module FormatEngine

  #A little package of info about the engine's progress.
  class SpecInfo

    #The source data for formatting, string input for parsing.
    attr_reader :src

    #The destination of the process.
    attr_reader :dst

    #The formatting engine.
    attr_reader :engine

    #A hash for state storage for the formatting/parsing process.
    attr_reader :tmp

    #The format specifier currently being processed.
    attr_reader :fmt

    # Set up the spec info.
    def initialize(src, dst, engine)
      @src, @dst, @engine, @tmp = src, dst, engine, {}
    end

    # Concatenate onto the formatted output string.
    def cat(str)
      @dst << str
    end

    # Set the result of this parsing operation.
    def set(obj)
      @dst = obj
    end

    #Pass the formatting action along to the current format element.
    def do_format(fmt)
      (@fmt = fmt).do_format(self)
    end

    #Pass the parsing action along to the current format element.
    def do_parse(fmt)
      (@fmt = fmt).do_parse(self)
    end

    # Parse the source string for a target string or regex or return nil.
    def parse(target)
      #Handle the width option if specified.
      if (width = fmt.width) > 0
        head, tail = src[0...width], src[width..-1] || ""
      else
        head, tail = src, ""
      end

      #Do the parse on the input string or regex.
      @prematch, @match, @postmatch = head.partition(target)

      #Analyze the results.
      if found?
        @src = @postmatch + tail
        @match
      else
        nil
      end
    end

    # Parse the source string for a target string or regex or raise error.
    def parse!(target, msg = "#{target.inspect} not found")
      fail "Parse error: #{msg}" unless parse(target)
      @match
    end

    #Grab some text
    def grab
      width = fmt.width

      if width > 0
        result, @src = src[0...width], src[width..-1] || ""
      elsif width == 0
        result, @src = src[0...1], src[1..-1] || ""
      elsif width == -1
        result, @src = src, ""
      else
        result, @src = src[0..width], src[(width+1)..-1] || ""
      end

      result
    end

    # Was the last parse a success?
    def found?
       @prematch.empty? && !@match.empty?
    end

    # What was found by the last parse?
    def found
      @match
    end
  end
end
