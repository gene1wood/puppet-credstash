# Install credstash using pip
class credstash(
  $credstash_package = 'credstash',
) {
  package { 'python-yaml' :
    name => $::osfamily ? {
      'redhat' => 'PyYAML',
      'debian' => 'python-yaml',
    }
  }

  package { 'python-crypto' : }

  python::pip { $credstash_package :
    require => [ Class['python'],
                 Package['python-yaml'],
                 Package['python-crypto']]
  }
}
