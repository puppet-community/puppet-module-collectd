# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::dns', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default values for all parameters' do
        it { is_expected.to contain_class('collectd::plugin::dns') }

        it do
          is_expected.to contain_file('dns.load').with(
            'ensure' => 'present'
          )
        end

        default_fixture = File.read(fixtures('plugins/dns.conf.default'))
        it { is_expected.to contain_file('dns.load').with_content(default_fixture) }

        it { is_expected.to contain_package('collectd-dns') }
      end

      describe 'with ensure parameter' do
        %w[present absent].each do |value|
          context "set to a valid value of #{value}" do
            let :params do
              { ensure: value }
            end

            it { is_expected.to contain_file('dns.load').with('ensure' => value) }
          end
        end
      end

      describe 'with ignoresource parameter' do
        context 'set to a valid IP address' do
          let :params do
            { ignoresource: '10.10.10.10' }
          end

          ignoresource_fixture = File.read(fixtures('plugins/dns.conf.ignoresource'))
          it { is_expected.to contain_file('dns.load').with_content(ignoresource_fixture) }
        end

        context 'set to undef' do
          it { is_expected.to contain_file('dns.load').without_content(%r{IgnoreSource\s+10\.10\.10\.10}) }
        end
      end

      describe 'with interface parameter' do
        context 'set to a valid value' do
          let :params do
            { interface: 'eth0' }
          end

          interface_fixture = File.read(fixtures('plugins/dns.conf.interface'))
          it { is_expected.to contain_file('dns.load').with_content(interface_fixture) }
        end
      end

      describe 'with interval parameter' do
        ['10.0', '3600'].each do |value|
          context "set to a valid numeric of #{value}" do
            let :params do
              { interval: value }
            end

            it { is_expected.to contain_file('dns.load').with_content(%r{\s*Interval\s+#{Regexp.escape(value)}}) }
          end
        end
      end

      describe 'with selectnumericquerytypes parameter' do
        ['true', true, 'false', false].each do |value|
          context "set to valid value of #{value}" do
            let :params do
              { selectnumericquerytypes: value }
            end

            it { is_expected.to contain_file('dns.load').with_content(%r{\s*SelectNumericQueryTypes\s+#{Regexp.escape(value.to_s)}}) }
          end
        end
      end

      describe 'with manage_package parameter' do
        ['true', true].each do |value|
          context "set to #{value}" do
            %w[present absent].each do |ensure_value|
              context "and ensure set to #{ensure_value}" do
                let :params do
                  {
                    ensure: ensure_value,
                    manage_package: value
                  }
                end

                it do
                  is_expected.to contain_package('collectd-dns').with(
                    'ensure' => ensure_value
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
