# Install credstash using pip
class credstash(
  $credstash_package = 'credstash',
) {
  include 'python'
  $python_yaml_package_name = $::osfamily ? {
    'redhat' => 'PyYAML',
    'debian' => 'python-yaml',
  }

  package { 'python-yaml' :
    name => $python_yaml_package_name,
  }

  package { 'python-crypto' : }

  python::pip { $credstash_package :
    require => [
      Class['python'],
      Package['python-yaml'],
      Package['python-crypto']
    ]
  }
}
