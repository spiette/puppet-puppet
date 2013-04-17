# === Class: puppet::config
class puppet::config {
  include concat::setup
  concat { '/etc/puppet/puppet.conf': }
}
