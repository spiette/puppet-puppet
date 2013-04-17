# == Class: puppet
#
# Full description of class puppet here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { puppet:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class puppet (
  $certname=$::fqdn,
  $server=$certname,
  $master=false,
  $autosign=false,
  $passenger=false,
  $puppetdb=false,
) {
  include concat::setup

  concat { '/etc/puppet/puppet.conf': }

  anchor { 'puppet::begin': } ->
  class { 'puppet::agent':
    server   => $server,
    certname => $certname
  }

  if $master {
    class { 'puppet::master':
      autosign  => $autosign,
      passenger => $passenger,
      certname  => $certname,
      puppetdb  => $puppetdb,
    } -> anchor { 'puppet::end': }
  } else {
    Class['puppet::agent'] -> anchor { 'puppet::end': }
  }
}
