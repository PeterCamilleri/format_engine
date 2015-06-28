#* mocks/demo/demo_formatting.rb - Formatting specifications for the \Customer class.
class Customer

  extend FormatEngine::AttrFormatter

  ##
  #The specification of the formatter method of the demo \Customer class.

  attr_formatter :strfmt,
  {"%f"  => lambda {cat src.first_name.ljust(fmt.width) },
   "%l"  => lambda {cat src.last_name.ljust(fmt.width)  } }

end
