# === Class: puppet::master::hiera
class puppet::master::hiera {
  file { '/etc/puppet/hieradata':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0600',
  }

  file { '/etc/puppet/hiera.yaml':
    ensure => present,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0600',
    source => "puppet:///modules/${module_name}/hiera.yaml",
  }

  file { '/etc/puppet/hieradata/global.yaml':
    ensure => present,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0600',
    source => "puppet:///modules/${module_name}/global.yaml",
  }
}
