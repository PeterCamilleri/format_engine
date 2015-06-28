module FormatEngine

  # The concrete class for the Parser.
  class Parser < Base

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
