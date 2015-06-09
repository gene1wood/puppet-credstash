require 'json'
##
# call-seq:
#    destringify(string) -> object
#
# Given a string created from a ruby inspect call, transform that string
# into a valid JSON string, parse the JSON string and return the resulting
# object.
#
#    mystring = '{:dbpassword=>"my \"special\" s3cret"}'
#    destringify(mystring)  #=> {"dbpassword":"my \"special\" s3cret"} 

module Puppet::Parser::Functions
  newfunction(:destringify, :type => :rvalue) do |args|
    # See http://json.org/

    string = args[0]
    # Transform object string symbols to quoted strings
    string.gsub!(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>')
     
    # Transform object string numbers to quoted strings
    string.gsub!(/([{,]\s*)([0-9]+\.?[0-9]*)\s*=>/, '\1"\2"=>')
     
    # Transform object value symbols to quotes strings
    string.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>\s*:([^,}\s]+\s*)/, '\1\2=>"\3"')
     
    # Transform array value symbols to quotes strings
    string.gsub!(/([\[,]\s*):([^,\]\s]+)/, '\1"\2"')
     
    # Transform object string object value delimiter to colon delimiter
    string.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>/, '\1\2:')

    result = JSON.parse(string)
    # result.inspect == string ? result : false
    result
  end
end