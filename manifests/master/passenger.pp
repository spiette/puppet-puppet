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

      # Passenger configuration
      file { '/etc/httpd/conf.d/puppetmaster.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0664',
        content => template('puppet/puppetmaster.conf.erb'),
        require => File['/usr/share/puppet/rack/puppetmasterd/public'],
        notify  => Service[$puppet::params::passenger_service],
      }
      file { [
        '/usr/share/puppet/',
        '/usr/share/puppet/rack',
        '/usr/share/puppet/rack/puppetmasterd',
        '/usr/share/puppet/rack/puppetmasterd/public',
        '/usr/share/puppet/rack/puppetmasterd/tmp',
      ]:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0664',
      }
      file { '/usr/share/puppet/rack/puppetmasterd/config.ru':
        ensure  => file,
        owner   => 'puppet',
        group   => 'puppet',
        mode    => '0664',
        source  => 'puppet:///modules/puppet/config.ru',
        notify  => Service[$puppet::params::passenger_service],
      }
      if (defined($::selinux) and $::selinux ) {
        selboolean { 'httpd_can_network_connect':
          persistent => true,
          value      => 'on',
        }
      }
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }
}
