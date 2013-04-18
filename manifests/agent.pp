# == Class: puppet::agent
class puppet::agent (
  $server = 'puppet',
  $ca_server = undef,
  $runinterval = '1800',
  $environment = 'production',
  $certname = $::fqdn,
  ){
  anchor { 'puppet::agent::begin': }->
  Package['puppet']->
  Class['puppet::agent::config']~>
  Service['puppet']->
  anchor { 'puppet::agent::end': }

  include concat::setup
  include puppet::config
  include puppet::agent::config

  package { 'puppet':
    ensure => present
  }

  service { 'puppet':
    ensure  => running,
    enable  => true,
    tag     => 'puppetconf',
  }
}
