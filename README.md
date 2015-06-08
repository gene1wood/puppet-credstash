#puppet-credstash

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet-credstash](#setup)
    * [What puppet-credstash affects](#what-puppet-credstash-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet-credstash](#beginning-with-puppet-credstash)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

puppet-credstash installs [credstash] [1] and surfaces all accessible credstash
credentials as a facter fact. puppet-credstash works on Puppet 3.x/4.x under
Debian or RedHat based systems.

##Module Description

puppet-credstash creates a custom fact containing a hash (or stringified hash in
Puppet 3.x) of all stored credentials in a [credstash] [1] credential store.
This enables you to access previously stored credentials easily in your puppet
manifests.

puppet-credstash also installs credstash using pip.

##Setup

###What puppet-credstash affects

* Installs python and python-pip through it's dependence on the 
[puppet-python] [2] module
* Installs [credstash] [1] using pip

###Setup Requirements

puppet-credstash reads an optional configuration file located at `/etc/puppet-
credstash.yaml`. This configuration file allows you to pass optional
configuration options to credstash. The file is a YAML hash/dictionary of
settings.

As this configuration file is consumed by the puppet-credstash custom fact it
must be created before puppet runs, not by puppet.

#### region

Override the default credstash 
[AWS region] [3] 
of `us-east-1` with this setting

#### table

Override the default credstash [DynamoDB] [4] table name of `credential-store`
with this setting

#### context

This list enumerates the [AWS KMS] [5] [Encryption Contexts] [6] to use when
fetching credentials. Each Encryption Context is in the form of `key=value`

#### Example /etc/puppet-credstash.yaml

~~~yaml
    region: us-west-2
    table: credentials
    context:
    - environment=prod
    - app_tier=web
    - product=MyApp
~~~

###Beginning with puppet-credstash

Include the module [as you would any other] [7]

##Usage

To use a credential fetched by puppet-credstash use the `$credstash` fact. 

###Puppet 3.x

With puppet 3.x, non-string facts, like the `$credstash` hash, are [converted to
strings] [8].

There are two methods to handle non-string facts in Puppet 3.x

You can configure puppet to not convert facts to strings with the
[stringify_facts] [9] configuration setting.

You can parse the "stringified" `$credstash` fact in your puppet manifest with
the [parsejson] [10] function provided by the [puppetlabs-stdlib] [11] module.
To do this you would need to install the puppet-stdlib module and use the
`parsejson` function like this

~~~puppet
  class example() {
    $credstash_secrets = parsejson($credstash)
    $app_password = $credstash_secrets['app_password']
    file { '/etc/app.conf':
      content => template('example/app.conf.erb'),
    }
  }
~~~

###Puppet 4.x

The fetched credentials are stored in the `$credstash` hash. Access them like this

~~~puppet
  class example() {
    $app_password = $credstash['app_password']
    file { '/etc/app.conf':
      content => template('example/app.conf.erb'),
    }
  }
~~~

##Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

Classes:

* [credstash](#class-credstash)

Facts:

* [credstash](#fact-credstash)

Prerequisites:

* [AWS state](#prerequisite-aws-state)
* [Configuration file](#prerequisite-configuration-file)
* [Stored credentials](#prerequisite-stored-credentials)

###Class: credstash

Installs credstash using pip.

Include the `credstash` class to install credstash:

~~~puppet
  class { 'credstash': }
~~~

###Fact: credstash

A Facter fact that contains all of the fetched credentials in the form of a hash
of credentials names and secrets (or a stringified hash in Puppet 3.x).

~~~ruby
    {"app_password"  => "s3cret",
     "cookie_secret" => "52af5423-3593-4d70-9a98-2ee2e5d9ad08"}
~~~

###Prerequisite: AWS state

[credstash] [1] uses either IAM policy permissions or KMS Grants to decrypt the
encrypted credentials from the DynamoDB table. Without these permissions,
puppet-credstash will return no credentials as credstash won't have access to
any. To learn more about the permissions needed by credstash visit the
[credstash site] [1]

###Prerequisite: Configuration file

The puppet-credstash configuration file, `/etc/puppet-credstash.yaml` is
optional. If you're using a non-default AWS region or DynamoDB table name you
will need to set this in this configuration file. If you're using Encryption
Contexts to control access to your stored credentials, you will need to set the
contexts in this configuration file.

###Prerequisite: Stored credentials

puppet-credstash fetches and decrypts credentials. These credentials must have
previously been encrypted and uploaded with credstash.

##Limitations

puppet-credstash has been tested on RedHat based systems and should also work
under Debian systems.

Currently, credstash 1.3.1 does not store the encryption contexts used for 
encryption when credentials are stored. As a result, in order for
puppet-credstash to fetch credentials with credstash, that encryption context
must be provided in the puppet-credstash configuration file. Since the
puppet-credstash configuration file must be present *before* facter runs and
as a result *before* puppet runs, it would have to be made available by being
burned into the AMI, written by a `user_data` driven script or by some other
non-puppet means. This is not ideal. Once credstash supports recording of
encryption contexts, this dependence on a puppet-credstash configuration file
can be removed.

##Development

Feel free to [fork this module on github] [12] and contribute. Pull Requests are
welcome.

[1]: https://github.com/LuminalOSS/credstash "Credstash"
[2]: https://forge.puppetlabs.com/stankevich/python "puppet-python module"
[3]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions-availability-zones "AWS Regions"
[4]: http://aws.amazon.com/dynamodb/ "DynamoDB"
[5]: http://aws.amazon.com/kms/ "Key Management Service"
[6]: http://docs.aws.amazon.com/kms/latest/developerguide/encrypt-context.html "Encryption Contexts"
[7]: https://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html#using-modules "Using Modules"
[8]: https://docs.puppetlabs.com/puppet/latest/reference/lang_facts_and_builtin_vars.html#handling-boolean-facts-in-older-puppet-versions "stringifying facts"
[9]: https://docs.puppetlabs.com/puppet/3.8/reference/deprecated_settings.html#stringifyfacts--true "stringify_facts"
[10]: https://forge.puppetlabs.com/puppetlabs/stdlib#parsejson "parsejson function"
[11]: https://forge.puppetlabs.com/puppetlabs/stdlib "puppet-stdlib module"
[12]: https://github.com/gene1wood/puppet-credstash "puppet-credstash module"
