# === Class: puppet::master::hiera
#
# This class will set hiera files and directories. Defaults are provided, but
# they can be overriden.
#
# === Parameters
#
# [*ensure*]
#   whether the hiera package will be present or latest
#
# [*hieraconfig*]
#   a source option to override the one provided with the module
#   no directories will be created.
#
# [*datadir*]
#   where to find the yaml files, defaults to /etc/puppet/hieradata
#
# === Author
#
# Simon Piette <simon.piette@savoirfairelinux.com>
#
# === Copyright
#
# Copyright 2013 Simon Piette <simon.piette@savoirfairelinux.com>
# Apache 2.0 Licence
#
class puppet::master::hiera (
  $ensure = present,
  $hieraconfig = "puppet:///modules/${module_name}/hiera.yaml",
  $datadir = '/etc/puppet/hieradata',
  $merge_behaviour = 'native',
) {

  if ( $hieraconfig != 'puppet:///modules/puppet/hiera.yaml' ) {
    file { '/etc/puppet/hiera.yaml':
      ensure => present,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0664',
      source => $hieraconfig,
    }
  } else  {
    file { '/etc/puppet/hiera.yaml':
      ensure  => present,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0664',
      content => template('puppet/hiera.yaml.erb'),
    }
    if ( $datadir == '/etc/puppet/hieradata') {
      file { '/etc/puppet/hieradata':
        ensure => directory,
        owner  => 'puppet',
        group  => 'puppet',
        mode   => '0661',
      }
    }
  }


  if $ensure in [ present, latest ] {
    package { 'hiera':
      ensure => $ensure,
    }
  } else {
    fail('puppet::master::hiera: ensure should be present or latest')
  }
}
