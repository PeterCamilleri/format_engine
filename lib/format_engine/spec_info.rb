module FormatEngine

  #A little package of info about the engine's progress.
  #In the context of a formatting / parsing block, the
  #"self" of that block is an instance of SpecInfo.
  #<br>
  #<br>The components of that instance Struct are:
  #<br>
  #<br>When Formatting:
  #* src - The object that is the source of the data.
  #* dst - A string that receives the formatted output.
  #* fmt - The format specification currently being processed.
  #* engine - The formatting engine. Mostly for access to the library.
  #* hsh - A utility hash so that the formatting process can retain state.
  #<br>When Parsing:
  #* src - A string that is the source of formatted input.
  #* dst - The class of the object being created.
  #* fmt - The parse specification currently being processed.
  #* engine - The parsing engine. Mostly for access to the library.
  #* hsh - A utility hash so that the parsing process can retain state.
  SpecInfo = Struct.new(:src, :dst, :fmt, :engine, :hsh)

end