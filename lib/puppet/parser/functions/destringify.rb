require 'json'
# @summary
#   Given a string created from a ruby inspect call, transform that string
#   into a valid JSON string, parse the JSON string and return the resulting
#   object.
#
#    mystring = '{:dbpassword=>"my \"special\" s3cret"}'
#    destringify(mystring)  #=> {"dbpassword":"my \"special\" s3cret"}
#
Puppet::Functions.create_function(:'credstash::destringify') do
  # @param string_repr
  #   A string representation of a ruby inspect call
  #
  # @return object
  #   An object representing the JSON parsed output of the string_repr
  #
  dispatch :destringify do
    param 'String', :string_repr
  end

  def destringify(string_repr)

    # See http://json.org/
    # https://stackoverflow.com/a/30724359/168874

    # Transform object string symbols to quoted strings
    string_repr.gsub!(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>')
     
    # Transform object string numbers to quoted strings
    string_repr.gsub!(/([{,]\s*)([0-9]+\.?[0-9]*)\s*=>/, '\1"\2"=>')
     
    # Transform object value symbols to quotes strings
    string_repr.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>\s*:([^,}\s]+\s*)/, '\1\2=>"\3"')
     
    # Transform array value symbols to quotes strings
    string_repr.gsub!(/([\[,]\s*):([^,\]\s]+)/, '\1"\2"')
     
    # Transform object string object value delimiter to colon delimiter
    string_repr.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>/, '\1\2:')

    result = JSON.parse(string_repr)
    # result.inspect == string ? result : false
    result
  
  end
end
