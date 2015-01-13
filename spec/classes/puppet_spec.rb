require 'spec_helper'

package = 'puppet'
service = package
fqdn = 'agent.domain.local'
server = 'puppet.domain.local'
agent_options = { 'splay' => 'true' }

describe 'puppet' do
  let(:title) { 'puppet' }

  ['Debian', 'RedHat'].each do |osfamily|
    context "class with some parameters on #{osfamily}" do 
      let(:params) { {
        :certname => fqdn,
        :server   => server,
        :master => 'true',
        :environment => 'staging',
        :agent_options => agent_options,
        :mount_points => [ { 'name' => 'files', 'path' => '/etc/puppet/files', 'allow' => '*' } ],
        :master_options => { 'environment' => 'stage', 'environmentpath' => '/etc/puppet/environments' }
      } }
      let(:facts) { {
        :osfamily => osfamily,
        :fqdn => fqdn,
        :concat_basedir => '/var/lib/puppet/concat'
      } }

      it { should create_class('puppet') }
      it { should create_class('puppet::config') }
      it { should create_class('concat::setup') }
      it { should create_class('puppet::agent')\
        .with(
        'environment' => 'staging',
        'server' => server,
        'certname' => fqdn
      ) }
      it { should create_class('puppet::agent::config') }
      it { should create_class('puppet::master') }
      it { should create_concat('/etc/puppet/puppet.conf') }
      it { should create_package(package).with_ensure('present') }
      it { should create_concat__fragment('puppet_main_conf')\
           .with_content(/\[main\]/) }
      it { should create_concat__fragment('puppet_certname')\
           .with_content(/certname = #{fqdn}/) }
      it { should create_concat__fragment('puppet_agent_conf')\
           .with_content(/server      = #{server}/)\
           .with_content(/splay = true/) }
      it { should create_concat__fragment('puppet_master_conf')\
           .with_content(/environment = stage/)\
           .with_content(/environmentpath = .etc.puppet.environments/) }
      it { should create_service(service)\
           .with(
            'ensure' => 'running',
            'enable' => 'true',
            'tag'    => 'puppetconf'
           ) }
      it { should create_class('puppet::master::fileserver') }
      it { should create_file('/etc/puppet/fileserver.conf')\
           .with_content(/^\[files\]/)\
           .with_content(/^  path .etc.puppet.files/)\
           .with_content(/^  allow \*/)
      }
      if osfamily == 'Debian'
        it { should create_file('/etc/default/puppet')\
          .with_content(/^START=yes$/) }
      end
    end
  end
end
