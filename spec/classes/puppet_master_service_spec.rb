require 'spec_helper'

describe 'puppet::master::service' do
  let(:title) { 'puppet::master::service' }

  ['puppetmaster', 'apache2'].each do |service_name|
    context "class with #{service_name} param" do 
      let(:params) { { :service_name => service_name }}

      it { should create_class('puppet::master::service') }
      it { should create_service(service_name)\
        .with(
          :ensure => 'running',
          :enable => 'true',
          :tag => 'puppetconf'
          ) }
    end
  end
end
