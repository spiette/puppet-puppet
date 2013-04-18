# == Class: puppet::master::autosign
class puppet::master::autosign {
  file { '/etc/puppet/autosign.conf':
    ensure  => present,
    owner   => puppet,
    group   => puppet,
    mode    => '0600',
    content => '*',
  }
}
