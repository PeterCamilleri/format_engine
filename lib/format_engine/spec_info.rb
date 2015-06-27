module FormatEngine

  #A little package of info about the engine's progress.
  #In the context of a formatting / parsing block, the
  #"self" of that block is an instance of SpecInfo.
  #<br>
  #<br>The components of that instance Struct are:
  #<br>
  #<br>When Formatting:
  #* src - The object that is the source of the data.
  #* dst - A string that receives the formatted output.
  #* fmt - The format specification currently being processed.
  #* engine - The formatting engine. Mostly for access to the library.
  #* hsh - A utility hash so that the formatting process can retain state.
  #<br>Methods
  #* cat - Append the string that follows to the formatted output.
  #<br>
  #<br>When Parsing:
  #* src - A string that is the source of formatted input.
  #* dst - The class of the object being created.
  #* fmt - The parse specification currently being processed.
  #* engine - The parsing engine. Mostly for access to the library.
  #* hsh - A utility hash so that the parsing process can retain state.
  #<br>Methods
  #* set - Set the return value of the parsing operation to the value that follows.
  #* parse - Look for the string or regex parm that follows. Return the data found or nil.
  #* parse! - Like parse but raises an exception (with optional msg) if not found.
  #* found? - Did the last parse succeed?
  #* found - The text found by the last parse (or parse!) operation.
  class SpecInfo

    # General readers
    attr_reader :src, :dst, :engine, :hsh

    #General accessors
    attr_accessor :fmt

    # Set up the spec info.
    def initialize(src, dst, fmt, engine, hsh = {})
      @src, @dst, @fmt, @engine, @hsh = src, dst, fmt, engine, hsh
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