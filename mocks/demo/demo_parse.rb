#* mocks/demo/demo_parse.rb - Parsing specifications for the \Customer class.
class Customer

  extend FormatEngine::AttrParser

  ##
  #The specification of the parser method of the demo \Customer class.

  @parser_engine = attr_parser :strprs,
  {"%a"    => lambda { tmp[:age] = found.to_i if parse(/\d+/) },
   "%f"    => lambda { tmp[:fn] = found.gsub(/_/, ' ') if parse(/\w+/) },
   "%l"    => lambda { tmp[:ln] = found.gsub(/_/, ' ') if parse(/\w+/) },
   :after  => lambda do
                fail  "Customer strprs error, missing field: first name" unless tmp[:fn]
                fail  "Customer strprs error, missing field: last name" unless tmp[:ln]
                fail  "Customer strprs error, missing field: age" unless tmp[:age]
                set dst.new(tmp[:fn], tmp[:ln], tmp[:age])
              end
  }

  class << self
    attr_reader :parser_engine
  end
end
