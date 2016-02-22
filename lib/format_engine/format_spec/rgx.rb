module FormatEngine

  #A format engine set specification.
  class FormatRgx

    #The full name of the set.
    attr_reader :long_name

    #The short form name of the set.
    attr_reader :short_name

    #The regular expression part of this set specification.
    attr_reader :regex

    #The width parameter. Handled internally so this is always zero.
    def width
      0
    end

    #Setup a variable format specification.
    def initialize(format)
      @long_name = format
      pre, _, post = format.partition('/')
      @short_name = pre + '/'

      exp, _, options = post.partition(/(?<=[^\\])\// )
      opt = (options.include?('x') ? Regexp::EXTENDED   : 0) |
            (options.include?('i') ? Regexp::IGNORECASE : 0) |
            (options.include?('m') ? Regexp::MULTILINE  : 0)

      @regex = Regexp.new(exp.gsub(/\\\//, '/'), opt)
    end

    #Is this format item supported by the engine's library?
    def validate(engine)
      @block = engine[@long_name] || engine[@short_name]
      fail "Unsupported tag = #{@raw.inspect}" unless @block
      true
    end

    #Format onto the output string
    def do_format(spec_info)
      fail "The tag %{@raw} may not be used in formatting."
    end

    #Parse from the input string
    def do_parse(spec_info)
      spec_info.instance_exec(&@block)
    end

    #Inspect for debugging.
    def inspect
      "Regex(#{@long_name.inspect}, #{@short_name.inspect}, #{regex.inspect})"
    end

  end

end
