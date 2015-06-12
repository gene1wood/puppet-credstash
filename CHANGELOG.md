#2015-06-11 - Release 0.6.3
## Summary

Linting and adding EPEL dependency to workaround [puppet-python bug](https://github.com/stankevich/puppet-python/issues/196)

#2015-06-11 - Release 0.6.2
## Summary

Install OS package prerequisites instead of depending on pip.

#2015-06-11 - Release 0.6.1
## Summary

Handle absent puppet-credstash config file and credstash binary gracefully. 
Documentation cleanup.

#2015-06-09 - Release 0.6.0
## Summary

Changed $::credstash fact format from string to object and added new ways to
access credstash data.

## Features
- Add $::credstash_example fact for each credential
- Add get_credential function to fetch credential
- Add destringify function
- Add unescape function

#2015-06-08 - Release 0.5.0
## Summary
Initial release
