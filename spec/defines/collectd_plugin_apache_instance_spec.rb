# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::apache::instance', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let(:title) { 'foo.example.com' }
      let(:required_params) do
        {
          url: 'http://localhost/mod_status?auto'
        }
      end
      let(:filename) { 'apache-instance-foo.example.com.conf' }

      options = os_specific_options(facts)

      context 'default params' do
        let(:params) { required_params }

        it do
          is_expected.to contain_file(filename).with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/25-apache-instance-foo.example.com.conf"
          )
        end

        it { is_expected.to contain_file(filename).that_notifies('Service[collectd]') }
        it { is_expected.to contain_file(filename).with_content(%r{<Plugin "apache">}) }
        it { is_expected.to contain_file(filename).with_content(%r{<Instance "foo\.example\.com">}) }
        it { is_expected.to contain_file(filename).with_content(%r{URL "http://localhost/mod_status\?auto"}) }
        it { is_expected.to contain_file(filename).without_content(%r{User "}) }
        it { is_expected.to contain_file(filename).without_content(%r{Password "}) }
        it { is_expected.to contain_file(filename).without_content(%r{VerifyHost "}) }
        it { is_expected.to contain_file(filename).without_content(%r{CACert "}) }
      end

      context 'all params set' do
        let(:params) do
          required_params.merge(
            url: 'http://bar.example.com/server-status?auto',
            user: 'admin',
            password: 'admin123',
            verifypeer: false,
            verifyhost: false,
            cacert: '/etc/ssl/certs/ssl-cert-snakeoil.pem'
          )
        end

        it { is_expected.to contain_file(filename).with_content(%r{URL "http://bar\.example\.com/server-status\?auto"}) }
        it { is_expected.to contain_file(filename).with_content(%r{User "admin"}) }
        it { is_expected.to contain_file(filename).with_content(%r{Password "admin123"}) }
        it { is_expected.to contain_file(filename).with_content(%r{VerifyPeer false}) }
        it { is_expected.to contain_file(filename).with_content(%r{VerifyHost false}) }
        it { is_expected.to contain_file(filename).with_content(%r{CACert "/etc/ssl/certs/ssl-cert-snakeoil\.pem"}) }
      end
    end
  end
end
