require 'spec_helper'

package = 'puppet'
service = package
fqdn = 'agent.domain.local'
server = 'puppet.domain.local'

describe 'puppet::master::hiera' do
  let(:title) { 'puppet::master::hiera' }

  context "class" do 
    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn
    } }

    permissions = {
      :owner => 'puppet',
      :group => 'puppet',
      :mode  => '0600'
    } 
    it { should create_class('puppet::master::hiera') }
    it { should create_file('/etc/puppet/hieradata')\
      .with(permissions.merge({ :ensure => :directory }) ) }
    it { should create_file('/etc/puppet/hiera.yaml')\
      .with(permissions.merge( {
        :ensure => :present,
        :source => "puppet:///modules/puppet/hiera.yaml"
        } ) ) }
    it { should create_file('/etc/puppet/hieradata/global.yaml')\
      .with(permissions.merge( {
        :ensure => :present,
        :source => "puppet:///modules/puppet/global.yaml"
        } ) ) }
  end
end
