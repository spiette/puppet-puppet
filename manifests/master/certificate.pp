# === Class: puppet::master::certificate
class puppet::master::certificate (
  $waitforcert = '120',
) {
    include puppet
    $wait = "--waitforcert ${waitforcert}"
    $command = "/usr/bin/puppet agent --ca_server ${puppet::ca_server}"

    $puppet_ssl = '/var/lib/puppet/ssl'

    exec { 'puppet-cert-request':
      command => "${command} ${wait} ${puppet::certname}",
      creates => "${puppet_ssl}/certs/${puppet::certname}.pem",
      timeout => $waitforcert + 60,
      require => Package['puppet'],
    }

    exec { 'create-ca-directory':
      command => "/bin/mkdir -p ${puppet_ssl}/ca",
      creates => "${puppet_ssl}/ca",
    }

    exec { 'link-ca-crl':
      command => "/bin/ln -s ${puppet_ssl}/crl.pem ${puppet_ssl}/ca/ca_crl.pem",
      creates => "${puppet_ssl}/ca/ca_crl.pem",
      require => Exec['create-ca-directory', 'puppet-cert-request'],
    }
}


