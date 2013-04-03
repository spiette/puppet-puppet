class puppet::agent {
  package { 'puppet':
    ensure => present
  }
}
