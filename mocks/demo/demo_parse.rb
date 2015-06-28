#* mocks/demo/demo_parse.rb - Parsing specifications for the \Customer class.
class Customer

  extend FormatEngine::AttrParser

  ##
  #The specification of the parser method of the demo \Customer class.

  attr_parser :strprs,
  {"%f"    => lambda { hsh[:fn] = found if parse(/(\w)+/ ) },
   "%l"    => lambda { hsh[:ln] = found if parse(/(\w)+/ ) },
   :after  => lambda { set dst.new(hsh[:fn], hsh[:ln]) } }

end