
module FormatEngine

  # This module adds the attr_formatter extension to a class.
  module AttrFormat

    # Define a formatter on the current class.
    def attr_formatter(method, library)
      engine = Engine.new(library)

      define_method(method) do |spec_str|
        spec = FormatEngine::FormatSpec.get_spec(spec_str)

        engine.do_format(self, spec)
      end

    end

  end

end
