# == Class: puppet::master::autosign
class puppet::master::autosign {
  file { '/etc/puppet/autosign.conf':
    owner   => puppet,
    group   => puppet,
    mode    => '0644',
    content => '*',
  }
}
