##
# call-seq:
#    get_credential(string) -> string
#
# Fetch a specific credstash credential from the credstash facter fact
# whether the fact is a Puppet 3.x stringified hash or a Puppet 4.x
# hash. After unescaping the credential return it.
#
#    get_credential('app_password')  #=> s3cret
#    get_credential('my_roles')  #=> ["arn:aws:iam::012345678901:role/myrole",
#                                    "arn:aws:iam::123456789012:role/myrole"]

module Puppet::Parser::Functions
  newfunction(:get_credential, :type => :rvalue) do |args|
    credstash = lookupvar('credstash')
    if args.empty? or not args[0].is_a? String
      nil
    elsif credstash.is_a? Hash and credstash.has_key? args[0]
      credstash[args[0]]
    elsif credstash.is_a? String
      # Puppet 3.x with stringify_facts = true (default)
      credentials = function_destringify([credstash])
      credentials.has_key?(args[0]) ? function_unescape([credentials[args[0]]]) : nil
    else
      nil
    end
  end
end