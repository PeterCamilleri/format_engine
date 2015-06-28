# Formatting specifications for the Customer class.
class Customer

  extend FormatEngine::AttrFormat

  attr_formatter :strfmt, {
    "%f"  => lambda {cat src.first_name.ljust(fmt.width) },
    "%l"  => lambda {cat src.last_name.ljust(fmt.width)  }
  }

end
