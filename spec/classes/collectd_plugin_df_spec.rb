# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::df', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'simple case' do
        let :params do
          {}
        end

        it "Will create #{options[:plugin_conf_dir]}/10-df.conf" do
          is_expected.to contain_file('df.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-df.conf",
            content: %r{LoadPlugin df}
          )
        end
      end

      context 'devices case' do
        let :params do
          {
            devices: %w[proc sysfs]
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-df.conf" do
          is_expected.to contain_file('df.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-df.conf",
            content: %r{  Device "proc"\n  Device "sysfs"\n}
          )
        end
      end

      context 'ensure => absent' do
        let :params do
          {
            ensure: 'absent'
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-df.conf" do
          is_expected.to contain_file('df.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-df.conf"
          )
        end
      end
    end
  end
end
