# === Class: puppet::master::certificate
class puppet::master::certificate (
  $waitforcert = '120',
) {
    include puppet::config
    $wait = "--waitforcert ${waitforcert}"
    $command = '/usr/bin/puppet cert generate'
    exec { 'puppet-cert-generate':
      command => "${command} ${wait} ${puppet::certname}",
      creates => "/var/lib/puppet/ssl/certs/${puppet::certname}.pem",
      timeout => $waitforcert + 60,
    }
}


