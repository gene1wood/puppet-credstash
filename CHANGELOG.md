# 2024-04-24 - Release 1.0.0
## Summary

Converting to Puppet 4.x API

# 2017-05-27 - Release 0.6.4
## Summary

Adding support for Amazon Linux ([thanks to @webratz](https://github.com/gene1wood/puppet-credstash/pull/3))

# 2015-06-11 - Release 0.6.3
## Summary

Linting and adding EPEL dependency to workaround [puppet-python bug](https://github.com/stankevich/puppet-python/issues/196)

# 2015-06-11 - Release 0.6.2
## Summary

Install OS package prerequisites instead of depending on pip.

# 2015-06-11 - Release 0.6.1
## Summary

Handle absent puppet-credstash config file and credstash binary gracefully. 
Documentation cleanup.

# 2015-06-09 - Release 0.6.0
## Summary

Changed $::credstash fact format from string to object and added new ways to
access credstash data.

## Features
- Add $::credstash_example fact for each credential
- Add get_credential function to fetch credential
- Add destringify function
- Add unescape function

# 2015-06-08 - Release 0.5.0
## Summary
Initial release
