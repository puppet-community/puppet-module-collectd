# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::threshold', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :custom_params do
        {
          'types' => [
            {
              'name'        => 'foo',
              'warning_min' => 0.00,
              'warning_max' => 1000.00,
              'failure_min' => 0.00,
              'failure_max' => 1200.00,
              'invert'      => false,
              'instance'    => 'bar'
            }
          ],
          'plugins' => [
            {
              'name'     => 'interface',
              'instance' => 'eth0',
              'types'    => [
                {
                  'name'        => 'if_octets',
                  'failure_max' => 10_000_000,
                  'data_source' => 'rx'
                }
              ]
            }
          ],
          'hosts' => [
            {
              'name' => 'hostname',
              'types' => [
                {
                  'name'        => 'cpu',
                  'instance'    => 'idle',
                  'failure_min' => 10
                },
                {
                  'name'        => 'load',
                  'data_source' => 'midterm',
                  'failure_max' => 4,
                  'hits'        => 3,
                  'hysteresis'  => 3
                }
              ],
              'plugins' => [
                {
                  'name'  => 'memory',
                  'types' => [
                    {
                      'name'        => 'memory',
                      'instance'    => 'cached',
                      'warning_min' => 100_000_000
                    }
                  ]
                }
              ]
            }
          ]
        }
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        context ':ensure => present and default parameters' do
          it "Will create #{options[:plugin_conf_dir]}/10-threshold.conf to load the plugin" do
            is_expected.to contain_file('threshold.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-threshold.conf",
              content: %r{LoadPlugin threshold}
            )
          end
        end

        context ':ensure => present and empty configurations' do
          let :params do
            {
              'hosts' => [
                {
                  'name' => 'example.com'
                }
              ],
              'plugins' => [
                {
                  'name' => 'interface'
                }
              ]
            }
          end

          it { is_expected.to compile }
        end

        context ':ensure => present and custom parameters' do
          let :params do
            custom_params
          end

          it { is_expected.to contain_file('threshold.load').with(content: %r{<Type "foo">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{WarningMin 0\.0}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{WarningMax 1000\.0}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{FailureMin 0\.0}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{FailureMax 1200\.0}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{Invert false}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{Instance "bar"}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{<Plugin "interface">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{Instance "eth0"}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{<Type "if_octets">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{FailureMax 10000000}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{DataSource "rx"}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{<Host "hostname">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{<Type "cpu">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{Instance "idle"}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{FailureMin 10}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{<Plugin "memory">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{<Type "memory">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{Instance "cached"}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{WarningMin 100000000}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{<Type "load">}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{DataSource "midterm"}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{FailureMax 4}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{Hits 3}) }
          it { is_expected.to contain_file('threshold.load').with(content: %r{Hysteresis 3}) }
        end
      end
    end
  end
end
