# == Class puppet::master::passenger
class puppet::master::passenger {
  include puppet::params
  case $::osfamily {
    'RedHat': {
      $repohost = 'passenger.stealthymonkeys.com'
      $release_package = 'passenger-release.noarch.rpm'
      $release = $::operatingsystemmajrelease
      $os = $::operatingsystem ? {
        'Fedora' => 'fedora',
        default  => 'rhel',
      }
      package { 'passenger-release':
        ensure   => present,
        provider => 'rpm',
        source   => "http://${repohost}/${os}/${release}/${release_package}",
      }
      Package['passenger-release']->Package[$puppet::params::passenger_package]
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }
}
