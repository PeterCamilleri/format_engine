
module FormatEngine

  # This module adds the \attr_formatter extension to a class.
  module AttrFormatter

    #Define a formatter for instances of the current class.
    #<br>Parameters
    #* method - A symbol used to name the formatting method created by this method.
    #* library - A hash of formatting rules that define the formatting
    #  capabilities supported by this formatter.
    #<br>Meta-effects
    #* Creates a method (named after the symbol in method) that formats the
    #  instance of the class. The created method takes one parameter:
    #<br>Meta-method Parameters
    #* spec_str - A format specification string with %x etc qualifiers.
    #<br>Meta-method Returns
    #* A formatted string
    def attr_formatter(method, library)
      engine = Engine.new(library)

      #Create an instance method to do the formatting.
      define_method(method) do |spec_str|
        engine.do_format(self, spec_str)
      end

    end

  end

end
