require 'spec_helper'

package = 'puppet'
service = package
fqdn = 'agent.domain.local'
server = 'puppet.domain.local'
    permissions = {
      :owner => 'puppet',
      :group => 'puppet',
      :mode  => '0600'
    }

describe 'puppet::master::hiera' do
  let(:title) { 'puppet::master::hiera' }

  context "class" do
    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn,
      :concat_basedir => '/var/lib/puppet/concat'
    } }

    it { should create_class('puppet::master::hiera') }
    it { should create_package('hiera')\
      .with( :ensure => :present) }
    it { should create_file('/etc/puppet/hieradata')\
      .with(permissions.merge({ :ensure => :directory }) ) }
    it { should create_file('/etc/puppet/hiera.yaml')\
      .with(permissions.merge( {
        :ensure => :present,
        :source => 'puppet:///modules/puppet/hiera.yaml'
        } ) ) }
  end

  context "class with parameters" do
    let(:params) { {
      :ensure => 'latest',
      :hieraconfig => 'puppet:///files/hiera.yaml'
    } }
    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn,
      :concat_basedir => '/var/lib/puppet/concat'
    } }
    it { should create_class('puppet::master::hiera') }
    it { should create_file('/etc/puppet/hieradata')\
      .with(permissions.merge({ :ensure => :directory }) ) }
    it { should create_file('/etc/puppet/hiera.yaml')\
      .with(permissions.merge(
        { :source => 'puppet:///files/hiera.yaml' }
      ))}
    it { should create_package('hiera')\
      .with( :ensure => :latest) }
  end
end
