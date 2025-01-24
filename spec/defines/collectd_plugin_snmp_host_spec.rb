# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::snmp::host', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let(:title) { 'foo.example.com' }
      let(:filename) { 'snmp-host-foo.example.com.conf' }
      let(:required_params) do
        {
          collect: 'foo'
        }
      end

      options = os_specific_options(facts)

      context 'default params' do
        let(:params) { required_params }

        it do
          is_expected.to contain_file(filename).with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/25-snmp-host-foo.example.com.conf"
          )
        end

        it { is_expected.to contain_file(filename).that_notifies('Service[collectd]') }
        it { is_expected.to contain_file(filename).with_content(%r{<Plugin snmp>}) }
        it { is_expected.to contain_file(filename).with_content(%r{<Host "foo\.example\.com">}) }
        it { is_expected.to contain_file(filename).with_content(%r{Address "foo\.example\.com"}) }
        it { is_expected.to contain_file(filename).with_content(%r{Version 1}) }
        it { is_expected.to contain_file(filename).with_content(%r{Community "public"}) }
        it { is_expected.to contain_file(filename).without_content(%r{Interval \d+}) }
      end

      context 'all SNMPv2 params set' do
        let(:params) do
          required_params.merge(address: 'bar.example.com',
                                version: '2',
                                community: 'opensesame',
                                interval: 30)
        end

        it { is_expected.to contain_file(filename).with_content(%r{Address "bar\.example\.com"}) }
        it { is_expected.to contain_file(filename).with_content(%r{Version 2}) }
        it { is_expected.to contain_file(filename).with_content(%r{Community "opensesame"}) }
        it { is_expected.to contain_file(filename).with_content(%r{Interval 30}) }
      end

      context 'all SNMPv3 params set' do
        let(:params) do
          required_params.merge(address: 'bar.example.com',
                                version: 3,
                                username: 'collectd',
                                security_level: 'authPriv',
                                auth_protocol: 'SHA',
                                auth_passphrase: 'mekmitasdigoat',
                                privacy_protocol: 'AES',
                                privacy_passphrase: 'mekmitasdigoat',
                                interval: 30)
        end

        it { is_expected.to contain_file(filename).with_content(%r{Address "bar\.example\.com"}) }
        it { is_expected.to contain_file(filename).with_content(%r{Version 3}) }
        it { is_expected.to contain_file(filename).with_content(%r{Username "collectd"}) }
        it { is_expected.to contain_file(filename).with_content(%r{SecurityLevel "authPriv"}) }
        it { is_expected.to contain_file(filename).with_content(%r{AuthProtocol "SHA"}) }
        it { is_expected.to contain_file(filename).with_content(%r{AuthPassphrase "mekmitasdigoat"}) }
        it { is_expected.to contain_file(filename).with_content(%r{PrivacyProtocol "AES"}) }
        it { is_expected.to contain_file(filename).with_content(%r{PrivacyPassphrase "mekmitasdigoat"}) }
        it { is_expected.to contain_file(filename).with_content(%r{Interval 30}) }
      end

      context 'collect is an array' do
        let(:params) do
          {
            collect: %w[foo bar baz]
          }
        end

        it { is_expected.to contain_file(filename).with_content(%r{Collect "foo" "bar" "baz"$}) }
      end

      context 'collect is just a string' do
        let(:params) do
          {
            collect: 'bat'
          }
        end

        it { is_expected.to contain_file(filename).with_content(%r{Collect "bat"$}) }
      end
    end
  end
end
