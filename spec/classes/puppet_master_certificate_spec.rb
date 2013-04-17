require 'spec_helper'

package = 'puppet'
service = package
fqdn = 'agent.domain.local'
server = 'puppet.domain.local'

describe 'puppet::master::certificate' do
  let(:title) { 'puppet::certificate' }

  ['Debian', 'RedHat'].each do |osfamily|
    context "class with some parameters on #{osfamily}" do 
      let(:facts) { {
        :osfamily => osfamily,
        :fqdn => fqdn
      } }

      it { should create_class('puppet::master::certificate') }
      it { should create_package('puppet') }
      it { should create_exec('puppet-cert-generate')\
        .with(
          'command' => /generate.*#{fqdn}/,
          'creates' => /#{fqdn}.pem/,
          'timeout' => '180'
        ) }
    end
  end
end
