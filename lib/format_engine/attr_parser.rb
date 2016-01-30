module FormatEngine

  # This module adds the \attr_parser extension to a class.
  module AttrParser

    #Define a parser for the current class.
    #<br>Parameters
    #* method - A symbol used to name the parsing method created by this method.
    #* library - A hash of parsing rules the define the parsing
    #  capabilities supported by this parser.
    #<br>Meta-effects
    #* Creates a class method (named after the symbol in method) that parses in
    #  a string and creates an instance of the class. The created method takes
    #  two parameters:
    #<br>Meta-method Parameters
    #* src - A string of formatted data to be parsed.
    #* spec_str - A format specification string with %x etc qualifiers.
    #<br>Meta-method Returns
    #* An instance of the host class.
    def attr_parser(method, library)
      engine = Engine.new(library)

      #Create a class method to do the parsing.
      define_singleton_method(method) do |src, spec_str|
        engine.do_parse(src, self, spec_str)
      end

    end

  end

end
