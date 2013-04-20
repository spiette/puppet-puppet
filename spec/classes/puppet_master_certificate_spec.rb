require 'spec_helper'

package = 'puppet'
service = package
fqdn = 'agent.domain.local'
server = 'puppet.domain.local'

describe 'puppet::master::certificate' do
  let(:title) { 'puppet::certificate' }

  context "class with some parameters" do 
    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn
    } }

    it { should create_class('puppet::master::certificate') }
    it { should create_package('puppet') }
    it { should create_exec('puppet-cert-request')\
      .with(
        'command' => /agent.*#{fqdn}/,
        'creates' => /.*#{fqdn}.pem/,
        'timeout' => '180'
      ) }
    it { should create_exec('create-ca-directory')\
      .with(
        'command' => /mkdir -p .*.ca$/,
        'creates' => /.ca$/
      ) }
    it { should create_exec('link-ca-crl')\
      .with(
        'command' => /ln -s.*crl.pem.*ca_crl.pem$/,
        'creates' => /ca.ca_crl.pem$/
      ) }
  end
end
