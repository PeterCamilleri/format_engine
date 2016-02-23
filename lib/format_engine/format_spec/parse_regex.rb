module FormatEngine

  #The format string parser.
  class FormatSpec
    #The regular expression used to parse variable specifications.
    PARSE_REGEX =
      %r{(?<lead>  (^|(?<=[^\\]))%){0}
         (?<flags> [~@#$^&*=?_<>|!]*){0}
         (?<var> \g<lead>\g<flags>[-+]?(\d+(\.\d+)?)?[a-zA-Z]){0}
         (?<set> \g<lead>\g<flags>(\d+(,\d+)?)?\[([^\]\\]|\\.)+\]){0}
         (?<rgx> \g<lead>\g<flags>\/([^\\ \/]|\\.)*\/([imx]*)){0}
         (?<per> \g<lead>%){0}
         \g<var> | \g<set> | \g<rgx> | \g<per>
        }x
   end

end
