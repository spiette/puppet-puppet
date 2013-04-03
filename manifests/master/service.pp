# == Class: puppet::master::service
class puppet::master::service (
  $service_name=$puppet::master::service_name
  ){
  service { $service_name:
    ensure => running,
  }
}
