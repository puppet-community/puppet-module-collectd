# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::rabbitmq', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'package ensure' do
        context ':ensure => present' do
          let(:node) { 'testhost.example.com' }
          let :params do
            {
              config: {
                'Username' => 'guest',
                'Password' => 'guest',
                'Port'     => '15672',
                'Scheme'   => 'http',
                'Host'     => 'testhost.example.com',
                'Realm'    => 'RabbitMQ Management'
              }
            }
          end

          case [facts['os']['family'], facts['os']['release']['major']]
          when %w[RedHat 8], %w[RedHat 9], %w[Ubuntu 20.04]
            it { is_expected.to raise_error(%r{does not support Python 3}) }
          else
            it 'import collectd_rabbitmq.collectd_plugin in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_header').with_content(%r{Import "collectd_rabbitmq.collectd_plugin"})
            end

            it 'Load collectd_rabbitmq in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Module "collectd_rabbitmq.collectd_plugin"})
            end

            it 'default to Username guest in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Username "guest"})
            end

            it 'default to Password guest in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Password "guest"})
            end

            it 'default to Port 15672 in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Port "15672"})
            end

            it 'default to Scheme http in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Scheme "http"})
            end

            it 'Host should be set to $::fqdn python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Host "testhost.example.com"})
            end

            it 'Realm set to "RabbitMQ Management"' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Realm "RabbitMQ Management"})
            end
          end
        end

        context 'override custom TypesDB with new value' do
          let :params do
            { custom_types_db: '/var/custom/types.db' }
          end

          case [facts['os']['family'], facts['os']['release']['major']]
          when %w[RedHat 8], %w[RedHat 9], %w[Ubuntu 20.04]
            it { is_expected.to raise_error(%r{does not support Python 3}) }
          else
            it 'override custom TypesDB' do
              is_expected.to contain_file('rabbitmq.load').with_content(%r{TypesDB "/var/custom/types.db"})
            end
          end
        end

        context 'override Username to foo' do
          let :params do
            { config: { 'Username' => 'foo' } }
          end

          case [facts['os']['family'], facts['os']['release']['major']]
          when %w[RedHat 8], %w[RedHat 9], %w[Ubuntu 20.04]
            it { is_expected.to raise_error(%r{does not support Python 3}) }
          else
            it 'override Username to foo in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Username "foo"})
            end
          end
        end

        context 'override Password to foo' do
          let :params do
            { config: { 'Password' => 'foo' } }
          end

          case [facts['os']['family'], facts['os']['release']['major']]
          when %w[RedHat 8], %w[RedHat 9], %w[Ubuntu 20.04]
            it { is_expected.to raise_error(%r{does not support Python 3}) }
          else
            it 'override Username to foo in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Password "foo"})
            end
          end
        end

        context 'override Scheme to https' do
          let :params do
            { config: { 'Scheme' => 'https' } }
          end

          case [facts['os']['family'], facts['os']['release']['major']]
          when %w[RedHat 8], %w[RedHat 9], %w[Ubuntu 20.04]
            it { is_expected.to raise_error(%r{does not support Python 3}) }
          else
            it 'override Username to foo in python-config' do
              is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with_content(%r{Scheme "https"})
            end
          end
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        case [facts['os']['family'], facts['os']['release']['major']]
        when %w[RedHat 8], %w[RedHat 9], %w[Ubuntu 20.04]
          it { is_expected.to raise_error(%r{does not support Python 3}) }
        else
          it 'Will remove python-config' do
            is_expected.not_to contain_concat__fragment('collectd_plugin_python_conf_collectd_rabbitmq.collectd_plugin_config').with(ensure: 'present')
          end
        end
      end

      # based on manage_package from dns spec but I added support for multiple providers
      describe 'with manage_package parameter' do
        ['true', true].each do |value|
          context "set to #{value}" do
            %w[present absent].each do |ensure_value|
              %w[pip yum].each do |provider|
                %w[collectd-rabbitmq collectd_rabbitmq].each do |packagename|
                  context "and ensure set to #{ensure_value} for package #{packagename} with package_provider #{provider}" do
                    let :params do
                      {
                        ensure: ensure_value,
                        manage_package: value,
                        package_name: packagename,
                        package_provider: provider
                      }
                    end

                    case [facts['os']['family'], facts['os']['release']['major']]
                    when %w[RedHat 8], %w[RedHat 9], %w[Ubuntu 20.04]
                      it { is_expected.to raise_error(%r{does not support Python 3}) }
                    else
                      it do
                        is_expected.to contain_package(packagename).with(
                          'ensure' => ensure_value,
                          'provider' => provider
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
    end
  end
end
