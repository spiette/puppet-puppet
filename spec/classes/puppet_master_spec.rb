require 'spec_helper'

fqdn = 'master.domain.local'
autosign = 'true'
puppetmaster_package = 'puppetmaster'
puppetmaster_service = 'puppetmaster'

describe 'puppet::master' do
  let(:title) { 'puppet::master' }

  context "class with some parameters" do
    confdir = '/etc/puppet'
    let(:params) { {
      :certname => fqdn,
      :autosign => autosign,
      :options => {
        'environment' => 'staging',
        'modulepath' => "#{confdir}/production:#{confdir}/staging",
        'manifest' => "/etc/puppet/staging/site.pp"
      }
    } }

    let(:facts) { {
      :osfamily => 'Debian',
      :fqdn => fqdn
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

    it { should create_package(puppetmaster_package)\
      .with(:ensure => :present) }
    it { should create_service(puppetmaster_service)\
      .with(:ensure => :running, :enable => 'true') }
  end
end
