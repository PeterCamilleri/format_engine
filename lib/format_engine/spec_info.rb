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

    # Parse the source string for a string or regex
    def parse(tgt)
      @result = src.partition(tgt)

      if found?
        @src = @result[2]
        @result[1]
      else
        nil
      end
    end

    # Parse the source string for a string or regex or raise error.
    def parse!(tgt, msg = "#{tgt.inspect} not found")
      fail "Parse error: #{msg}" unless parse(tgt)
      found
    end

    # Was the last parse a success?
    def found?
       @result[0].empty? && !@result[1].empty?
    end

    # What was found by the last parse?
    def found
      @result[1]
    end
  end
end
