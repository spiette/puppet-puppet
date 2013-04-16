# == Class: puppet::master
class puppet::master(
  $autosign=false,
  $passenger=false,
  $certname=$::fqdn,
  $puppetdb=false,
  $options= {},
){
  if $passenger {
    $puppetmaster = 'puppetmaster-passenger'
    package { 'puppetmaster':
      ensure => absent,
    }
  } else {
    $puppetmaster = 'puppetmaster'
    package { 'puppetmaster-passenger':
      ensure => absent,
    }
  }
  $service_name = $passenger ? {
    true    => 'apache2',
    false   => 'puppetmaster',
    default => fail('$passenger is true or false'),
  }

  package { $puppetmaster:
    ensure => present,
  }

  include puppet::master::service

  # Client configuration should be done before the puppetmaster is
  # launched a first time, so certificates are correctly generated.
  Concat['/etc/puppet/puppet.conf']->
  File['/var/lib/puppet/reports']->
  Package[$puppetmaster]->
  Class['puppet::master::hiera']~>
  Service[$service_name]

  concat::fragment { 'puppet_master_conf':
    target  => '/etc/puppet/puppet.conf',
    content => template('puppet/puppet_master_conf.erb'),
    order   => '40',
  } ~>
  Service[$service_name]


  file { '/var/lib/puppet/reports':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0640',
  }

  # Autosign since we don't want to manage certificate at this point
  if $autosign {
    include puppet::master::autosign
  }
  include puppet::master::hiera
}
