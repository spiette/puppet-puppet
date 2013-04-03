class puppet::master::autosign {
    file { '/etc/puppet/autosign.conf':
        owner => puppet,
        group => puppet,
        mode => 600,
        source => "puppet:///modules/${module_name}/autosign.conf",
    }
}
