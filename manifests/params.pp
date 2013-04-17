# === Class: puppet::params
class puppet::params {
  case $::osfamily {
    'Debian': {
      $passenger_service = 'apache2'
    }
    'RedHat': {
      $passenger_service = 'httpd'
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
