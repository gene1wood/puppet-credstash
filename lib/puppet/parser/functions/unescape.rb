UNESCAPES = {
    'a' => "\x07", 'b' => "\x08", 't' => "\x09",
    'n' => "\x0a", 'v' => "\x0b", 'f' => "\x0c",
    'r' => "\x0d", 'e' => "\x1b", "\\\\" => "\x5c",
    "\"" => "\x22", "'" => "\x27"
}

##
# call-seq:
#    unescape(string) -> string
#
# Transform escaped characters back into their original unescaped form.
# Given a string with escaped charcters, return an unescaped string.
#
#    mystring = 'my \x22special\x22 s3cret'
#    unescape(mystring)  #=> my "special" s3cret"

module Puppet::Parser::Functions
  newfunction(:unescape, :type => :rvalue) do |args|
    # See http://stackoverflow.com/a/22090177/168874
    
    args[0].gsub(/\\(?:([#{UNESCAPES.keys.join}])|u([\da-fA-F]{4}))|\\0?x([\da-fA-F]{2})/) {
      if $1
        if $1 == '\\' then '\\' else UNESCAPES[$1] end
      elsif $2 # escape \u0000 unicode
        ["#$2".hex].pack('U*')
      elsif $3 # escape \0xff or \xff
        [$3].pack('H2')
      end
    }
  end
end