# === Class: puppet::params
class puppet::params {
  case $::osfamily {
    'Debian': {
      $passenger_service = 'apache2'
      $puppetmaster_pkg = 'puppetmaster'
    }
    'RedHat': {
      $passenger_service = 'httpd'
      $puppetmaster_pkg = 'puppet-server'
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
