# Install credstash using pip
class credstash() {
  python::pip { 'credstash' :
    require => Class['python'],
  }
}