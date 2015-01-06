require 'spec_helper'

fqdn = 'agent.domain.local'
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
      .with({ :ensure => :directory }) }
    it { should create_file('/etc/puppet/hiera.yaml')\
      .with( { :ensure => :present } )
      .with_content(/:datadir: .etc.puppet.hieradata/)
    }
  end

  context "class with hieraconfig param" do
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
    it { should create_file('/etc/puppet/hiera.yaml')\
      .with( { :source => 'puppet:///files/hiera.yaml' }
      )}
    it { should create_package('hiera')\
      .with( :ensure => :latest) }
  end
  context "class with datadir param" do
    let(:params) { {
      :ensure => 'latest',
      :datadir => '/etc/puppet/hieratest'
    } }
    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn,
      :concat_basedir => '/var/lib/puppet/concat'
    } }
    it { should create_class('puppet::master::hiera') }
    it { should create_file('/etc/puppet/hiera.yaml')\
      .with_content(/:datadir: .etc.puppet.hieratest/)
       }
    it { should create_package('hiera')\
      .with( :ensure => :latest) }
  end
end
