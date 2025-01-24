# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::ovs_events', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)

      context ':ensure => present' do
        let :params do
          { address: 'foo.bar.baz',
            interfaces: %w[bar baz],
            port: 666,
            socket: '/foo/bar/baz',
            send_notification: true,
            dispatch: false }
        end

        it "will create #{options[:plugin_conf_dir]}/10-ovs_events.conf" do
          is_expected.to contain_file('ovs_events.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-ovs_events.conf"
          )
        end

        it 'will create config which will contain port configuration' do
          is_expected.to contain_file('ovs_events.load').with(
            content: %r{Port 666}
          )
        end

        it 'will create config which will contain address configuration' do
          is_expected.to contain_file('ovs_events.load').with(
            content: %r{Address "foo.bar.baz"}
          )
        end

        it 'will create config which will contain socket configuration' do
          is_expected.to contain_file('ovs_events.load').with(
            content: %r{Socket "/foo/bar/baz"}
          )
        end

        it 'will create config which will contain interfaces configuration' do
          is_expected.to contain_file('ovs_events.load').with(
            content: %r{Interfaces "bar" "baz"}
          )
        end

        it 'will create config which will contain send_notification configuration' do
          is_expected.to contain_file('ovs_events.load').with(
            content: %r{SendNotification true}
          )
        end

        it 'will create config which will contain dispatch configuration' do
          is_expected.to contain_file('ovs_events.load').with(
            content: %r{DispatchValues false}
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "will not create #{options[:plugin_conf_dir]}/10-ovs_events.conf" do
          is_expected.to contain_file('ovs_events.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-ovs_events.conf"
          )
        end
      end

      case facts['os']['family']
      when 'RedHat'
        context 'on osfamily => RedHat' do
          it 'Will delete packaging config file' do
            is_expected.to contain_file('package_ovs_events.load').with_ensure('absent')
          end
        end
      end
    end
  end
end
