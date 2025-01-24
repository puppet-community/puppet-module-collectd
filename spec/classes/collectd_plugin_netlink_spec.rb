# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::netlink', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, specific params' do
        let :params do
          {
            interfaces: %w[eth0 eth1],
            verboseinterfaces: ['ppp0'],
            qdiscs: ['"eth0" "pfifo_fast-1:0"', '"ppp0"'],
            classes: ['"ppp0" "htb-1:10"'],
            filters: ['"ppp0" "u32-1:0"'],
            ignoreselected: false

          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-netlink.conf" do
          is_expected.to contain_file('netlink.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-netlink.conf"
          )
        end

        it { is_expected.to contain_file('netlink.load').with_content(%r{^<Plugin netlink>$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  Interface "eth0"$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  Interface "eth1"$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  VerboseInterface "ppp0"$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  QDisc "eth0" "pfifo_fast-1:0"$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  QDisc "ppp0"$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  Class "ppp0" "htb-1:10"$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  Filter "ppp0" "u32-1:0"$}) }
        it { is_expected.to contain_file('netlink.load').with_content(%r{^  IgnoreSelected false$}) }

        it { is_expected.to contain_package('collectd-netlink').with(ensure: 'present') } if facts['os']['family'] == 'RedHat'
      end

      context ':ensure => absent' do
        let :params do
          { interfaces: ['eth0'], ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-netlink.conf" do
          is_expected.to contain_file('netlink.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-netlink.conf"
          )
        end

        if facts['os']['family'] == 'RedHat'
          it do
            is_expected.to contain_package('collectd-netlink').with(
              ensure: 'absent'
            )
          end
        end
      end

      context ':interfaces is not an array' do
        let :params do
          { interfaces: 'eth0' }
        end

        it 'Will raise an error about :interfaces being a String' do
          is_expected.to compile.and_raise_error(%r{String})
        end
      end
    end
  end
end
