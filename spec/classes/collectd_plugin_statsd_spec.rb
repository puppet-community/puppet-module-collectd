# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::statsd', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context ':ensure => present' do
        context ':ensure => present and default parameters' do
          it 'Will create /etc/collectd.d/10-statsd.conf' do
            is_expected.to contain_file('statsd.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-statsd.conf",
              content: %r{<Plugin statsd>\n</Plugin>}
            )
          end
        end

        context ':ensure => present and hostname and port' do
          let :params do
            {
              ensure: 'present',
              host: '192.0.0.1',
              port: 9876
            }
          end

          it "Will create #{options[:plugin_conf_dir]}/10-statsd.conf" do
            is_expected.to contain_file('statsd.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-statsd.conf",
              content: %r{Host "192.0.0.1".+Port 9876}m
            )
          end
        end

        context ':ensure => present and countersum' do
          let :params do
            {
              ensure: 'present',
              countersum: true
            }
          end

          it "Will create #{options[:plugin_conf_dir]}/10-statsd.conf" do
            is_expected.to contain_file('statsd.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-statsd.conf",
              content: %r{CounterSum true}m
            )
          end
        end
      end

      context ':ensure => absent' do
        let :params do
          {
            ensure: 'absent'
          }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-statsd.conf" do
          is_expected.to contain_file('statsd.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-statsd.conf"
          )
        end
      end
    end
  end
end
