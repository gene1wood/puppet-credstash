## 
# A facter fact to make all credstash stored secrets available as both a 
# hashed fact for Puppet 4.x as well as individual string facts for puppet
# 3.x

require 'json'

module Facter::Util::Credstash
  class << self
    ##
    # call-seq:
    #    Facter::Util::Credstash.get_credstash_credentials() -> credential_hash
    #
    # Returns a hash of all credstash stored credentials
    #
    #    Facter::Util::Credstash.get_credstash_credentials()   #=> {"dbpassword"=>"s3cret"}

    def get_credstash_credentials
      config_file = '/etc/puppet-credstash.yaml'
      case Facter.value(:osfamily)
      when 'Debian'
        bin = '/usr/local/bin/credstash'
      when 'RedHat'
        bin = '/usr/bin/credstash'
      end
    
      if File.exist?(config_file)
        require 'yaml'
        config = YAML.load_file(config_file)
      else
        config = {}
      end
      Facter.debug "Config loaded: #{config}"
  
      command = bin
      command += config.has_key?('region') ? " --region #{config['region']}" : ""
      command += config.has_key?('table') ? " --table #{config['table']}" : ""
      command += " getall"
      command += config.has_key?('context') ? " " + config['context'].join(" ") : ""
      
      Facter.debug "Executing command : #{command}"
      # Note : Puppet 3.x stringifies hashed facts by default whereas Puppet 4.x does not
      # see https://docs.puppetlabs.com/references/3.8.latest/configuration.html#stringifyfacts
      begin
        JSON.parse(Facter::Core::Execution.exec(command))
      rescue
        {}
      end
    end

    ##
    # call-seq:
    #    Facter::Util::Credstash.transform_variable_name(name) -> name
    #
    # Returns a sanitized string, usable as a valid Puppet variable name
    #
    #    Facter::Util::Credstash.transform_variable_name('my#variable:name')   #=> credstash_my_variable_name

    def transform_variable_name(name)
      prefix = "credstash_"
      # https://docs.puppetlabs.com/puppet/latest/reference/lang_reserved.html#regular-expressions-for-variable-names
      prefix + name.tr('^a-zA-Z0-9_', '_')
    end
  end
end

credential_hash = Facter::Util::Credstash.get_credstash_credentials()

credential_hash.each do |name, secret|
  Facter.add(Facter::Util::Credstash.transform_variable_name(name)) do
    setcode { secret }
  end
end

Facter.add(:credstash) do
  setcode { credential_hash }
end


=begin

Example config_file contents :

region: us-west-2
table: credentials
context:
- environment=prod
- app_tier=web
- product=MyApp

=end