#* mocks/demo/demo_formatting.rb - Formatting specifications for the \Customer class.
class Customer

  extend FormatEngine::AttrFormatter

  ##
  #The specification of the formatter method of the demo \Customer class.

  attr_formatter :strfmt,
  {"%a"  => lambda {cat "%#{fmt.width_str}d" % src.age },
   "%f"  => lambda {cat "%#{fmt.width_str}s" % src.first_name },
   "%l"  => lambda {cat "%#{fmt.width_str}s" % src.last_name  }
  }

end
