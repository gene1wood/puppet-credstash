# @summary
#   Fetch a specific credstash credential from the credstash facter fact
#   whether the fact is a Puppet 3.x stringified hash or a Puppet 4.x
#   hash. After unescaping the credential return it.
#
#      get_credential('app_password')  #=> s3cret
#      get_credential('my_roles')  #=> ["arn:aws:iam::012345678901:role/myrole",
#                                      "arn:aws:iam::123456789012:role/myrole"]
Puppet::Functions.create_function(:'credstash::get_credential') do
  # @param credstash_key
  #   The credstash key to lookup a value for
  #
  # @return object
  #   The value for the given credstash key
  #
  dispatch :fetch_credstash_value do
    param 'String', :credstash_key
  end

  def fetch_credstash_value(credstash_key)

    credstash = lookupvar('credstash')
    if credstash.is_a? Hash and credstash.has_key? credstash_key
      credstash[credstash_key]
    elsif credstash.is_a? String
      # Puppet 3.x with stringify_facts = true (default)
      credentials = call_function('destringify', [credstash])
      credentials.has_key?(credstash_key) ? function_unescape([credentials[credstash_key]]) : nil
    else
      nil
    end

  end
end
