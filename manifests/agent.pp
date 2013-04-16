# == Class: puppet::agent
class puppet::agent (
  $server = 'puppet',
  $runinterval = '1800',
  $environment = 'production',
  $certname = $::fqdn,
  ){
  Package['puppet']->
  Concat::Fragment['puppet_agent_conf', 'puppet_certname']~>
  Service['puppet']
  package { 'puppet':
    ensure => present
  }
  include concat::setup

  # Note that puppet agent or master are restarted if needed
  concat::fragment {'puppet_main_conf':
    target  => '/etc/puppet/puppet.conf',
    content => template('puppet/puppet_main_conf.erb'),
    order   => '10',
  } ->
  Service <| tag == 'puppetconf' |>

  concat::fragment { 'puppet_certname':
    target  => '/etc/puppet/puppet.conf',
    content => "certname = ${certname}\n",
    order   => '20',
  } ->
  Service <| tag == 'puppetconf' |>

  concat::fragment { 'puppet_agent_conf':
    target  => '/etc/puppet/puppet.conf',
    content => template('puppet/puppet_agent_conf.erb'),
    order   => '30',
  } ->
  Service <| tag == 'puppet' |>

  file { '/etc/default/puppet':
    ensure  => present,
    content => template('puppet/default.erb')
  }
  service { 'puppet':
    ensure  => running,
    enable  => true,
    require => File['/etc/default/puppet'],
    tag     => 'puppetconf',
  }
}
