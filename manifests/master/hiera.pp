class puppet::master::hiera(){
    file { '/etc/puppet/hieradata':
        owner => puppet,
        group => puppet,
        mode => 600,
        ensure => "directory",
        alias => 'hieradata'
    }

    file { '/etc/puppet/hiera.yaml':
        owner => puppet,
        group => puppet,
        mode => 600,
        source => "puppet:///modules/${module_name}/hiera.yaml",
    }

    file { '/etc/puppet/hieradata/global.yaml':
        owner => puppet,
        group => puppet,
        mode => 600,
        source => "puppet:///modules/${module_name}/global.yaml",
        require => File['hieradata'],
    }

}
