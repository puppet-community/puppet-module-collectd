# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::interface', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and :interfaces => ["eth0"]' do
        let :params do
          { interfaces: ['eth0'] }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-interface.conf" do
          is_expected.to contain_file('interface.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-interface.conf",
            content: %r{Interface  "eth0"}
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { interfaces: ['eth0'], ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-interface.conf" do
          is_expected.to contain_file('interface.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-interface.conf"
          )
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

      context 'interface options should be set with collectd 5.6' do
        let :facts do
          facts.merge(collectd_version: '5.6.0')
        end
        let :params do
          {
            reportinactive: true
          }
        end

        it "Will include ValuesPercentage in #{options[:plugin_conf_dir]}/10-interface.conf" do
          is_expected.to contain_file('interface.load').with_content(%r{ReportInactive true})
        end
      end
    end
  end
end
