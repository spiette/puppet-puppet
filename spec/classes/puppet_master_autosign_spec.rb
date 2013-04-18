require 'spec_helper'

package = 'puppet'
service = package
fqdn = 'agent.domain.local'
server = 'puppet.domain.local'

describe 'puppet::master::autosign' do
  let(:title) { 'puppet::master::autosign' }

  context "class" do 
    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn
    } }

    it { should create_class('puppet::master::autosign') }
    it { should create_file('/etc/puppet/autosign.conf')\
      .with(
        :owner => 'puppet',
        :group => 'puppet',
        :mode  => '0600',
        :ensure => :present
        )\
      .with_content('*') }
  end
end
