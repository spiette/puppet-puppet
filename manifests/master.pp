class puppet::master(
  $service_name='puppetmaster',
  $autosign=false,  
){
  package {'puppetmaster-passenger':
    ensure => present
  }

  # /etc/puppet/puppet.conf
  # Class - require Package - Notify Service
  Package['puppetmaster-passenger']->
  Class['puppet::master::hiera']~>
  Service[$puppet::master::service_name]

  /*
  # ligne pour le puppet master
  concat::fragment {'/etc/puppet/puppet.conf':
    # partie [main]
    source => 'puppet:///modules/puppet/puppet_main.conf'
  }

  # ligne pour le puppet master
  concat::fragment {'/etc/puppet/puppet.conf':
    source => 'puppet:///modules/puppet/puppet_master.conf'
  }
  */
  # Autosign since we don't want to manage certificate at this point
  if $autosign {
    file { '/etc/puppet/autosign.conf':
      owner => puppet,
      group => puppet,
      mode => 600,
      content => '*',
      require => Package['puppetmaster-passenger'],
      notify => Service[$puppet::master::service_name],
    }
  }

  include puppet::master::hiera

}
