module FormatEngine

  # The concrete class for the Formatter.
  class Parser < Base

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

  end

end
