require 'spec_helper'

package = 'puppet'
service = package
fqdn = 'agent.domain.local'
server = 'puppet.domain.local'

describe 'puppet::master::fileserver' do
  let(:title) { 'puppet::master::fileserver' }

  context "class" do 
    let(:params) { {
      :mount_points => [
        {
          'name' => 'files',
          'path' => '/etc/puppet/files',
          'allow' => '*'
        }
      ]
    }}

    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn,
      :concat_basedir => '/var/lib/puppet/concat'
    } }

    it { should create_class('puppet::master::fileserver') }
    it { should create_file('/etc/puppet/fileserver.conf')\
      .with(
        :owner => 'puppet',
        :group => 'puppet',
        :mode  => '0600',
        :ensure => :file
        )\
      .with_content(/^\[files\]/)\
      .with_content(/^  path .etc.puppet.files/)\
      .with_content(/^  allow \*/)
    }
  end
  context "class with wrong fileserver param" do 
    let(:params) { {
      :mount_points => 'true'
    }}

    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn,
      :concat_basedir => '/var/lib/puppet/concat'
    } }

    it { expect { should create_class('puppet::master::fileserver') }.to\
      raise_error(Puppet::Error, /is not an Array/) }
  end
end
