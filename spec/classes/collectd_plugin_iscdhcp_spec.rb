# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::cuda', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'package ensure' do
        context ':ensure => present' do
          it 'import collectd_cuda.collectd_plugin in python-config' do
            is_expected.to contain_concat_fragment('collectd_plugin_python_conf_collectd_cuda.collectd_plugin_header').with_content(%r{Import "collectd_cuda.collectd_plugin"})
          end
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will remove python-config' do
          is_expected.not_to contain_concat__fragment('collectd_plugin_python_conf_collectd_cuda.collectd_plugin_header').with(ensure: 'present')
        end
      end

      # based on manage_package from dns spec but I added support for multiple providers
      describe 'with manage_package parameter' do
        [false, true].each do |value|
          context "set to #{value}" do
            %w[present absent].each do |ensure_value|
              %w[pip yum].each do |provider|
                %w[collectd-cuda collectd_cuda].each do |packagename|
                  context "and ensure set to #{ensure_value} for package #{packagename} with package_provider #{provider}" do
                    let :params do
                      {
                        ensure: ensure_value,
                        manage_package: value,
                        package_name: packagename,
                        package_provider: provider
                      }
                    end

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
