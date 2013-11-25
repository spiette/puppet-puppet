require 'spec_helper'

fqdn = 'master.domain.local'
autosign = ['*']
master_package = {
  'Debian' => 'puppetmaster',
  'RedHat' => 'puppet-server',
}
master_service = 'puppetmaster'
ca = 'true'

describe 'puppet::master' do
  let(:title) { 'puppet::master' }

  ['Debian', 'RedHat'].each do |osfamily|
    context "class with some parameters" do
      confdir = '/etc/puppet'
      let(:params) { {
        :certname => fqdn,
        :autosign => autosign,
        :ca => ca,
        :options => {
          'environment' => 'staging',
          'modulepath' => "#{confdir}/production:#{confdir}/staging",
          'manifest' => "/etc/puppet/staging/site.pp"
        }
      } }

      let(:facts) { {
        :osfamily => osfamily,
        :fqdn => fqdn,
        :concat_basedir => '/var/lib/puppet/concat'
      } }

      it { should create_class('concat::setup') }
      it { should create_class('puppet::params') }
      it { should create_class('puppet::config') }
      it { should create_class('puppet::master') }
      it { should create_class('puppet::master::hiera') }
      it { should create_class('puppet::master::service') }
      it { should create_concat('/etc/puppet/puppet.conf') }
      it { should create_concat__fragment('puppet_master_conf')\
        .with_content(/ssl_client_header/)\
        .with_content(/^environment = staging/)\
        .with_content(/^modulepath = #{confdir}\/production\:#{confdir}\/staging/)\
        .with_content(/^manifest = .etc.puppet.staging.site.pp$/) }
      if ca == false
        it { should create_class('puppet::master::certificate') }
      end
      if autosign == true
        it { should create_class('puppet::master::autosign') }
      end
      it { should create_file('/var/lib/puppet/reports')\
        .with(
          :ensure => :directory,
          :owner  => 'puppet',
          :group  => 'puppet',
          :mode   => '0640'
      ) }

      it { should create_package(master_package[osfamily])\
        .with(:ensure => :present) }
      it { should create_service(master_service)\
        .with(:ensure => :running, :enable => 'true') }
    end
  end
end
