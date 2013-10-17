# === Class: puppet::params
class puppet::params {
  case $::osfamily {
    'Debian': {
      $passenger_service = 'apache2'
      $passenger_package = 'puppetmaster-passenger'
      $puppetmaster_package = 'puppetmaster'
    }
    'RedHat': {
      $passenger_service = 'httpd'
      $passenger_package = 'mod_passenger'
      $puppetmaster_package = 'puppet-server'
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
