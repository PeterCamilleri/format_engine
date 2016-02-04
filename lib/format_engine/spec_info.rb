module FormatEngine

  #A little package of info about the engine's progress.
  class SpecInfo

    #The source data for formatting, string input for parsing.
    attr_reader :src

    #The destination of the process.
    attr_reader :dst

    #The formatting engine.
    attr_reader :engine

    #State storage for the formatting/parsing process.
    attr_reader :tmp

    #The format specifier currently being processed.
    attr_accessor :fmt

    # Set up the spec info.
    def initialize(src, dst, engine, tmp = {})
      @src, @dst, @engine, @tmp = src, dst, engine, tmp
    end

    # Concatenate onto the formatted output string.
    def cat(str)
      @dst << str
    end

    # Set the result of this parsing operation.
    def set(obj)
      @dst = obj
    end

    # Parse the source string for a target string or regex or return nil.
    def parse(target)
      #Handle the width option if specified.
      if (width = fmt.width) > 0
        head, tail = src[0...width], src[width..-1] || ""
      else
        head, tail = src, ""
      end

      #Do the parse on the input string.
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
