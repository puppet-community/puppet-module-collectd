# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::snmp_agent', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      options = os_specific_options(facts)

      context ':ensure => present and default parameters' do
        it "Will create #{options[:plugin_conf_dir]}/10-snmp_agent.conf to load the plugin" do
          is_expected.to contain_file('snmp_agent.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-snmp_agent.conf"
          )
        end
      end

      it { is_expected.to contain_file('snmp_agent.load').with_content(%r{OIDs "IF-MIB::ifInOctets" "IF-MIB::ifOutOctets"}) }
      it { is_expected.to contain_file('snmp_agent.load').with_content(%r{<Data "ifOctets">}) }
      it { is_expected.to contain_file('snmp_agent.load').with_content(%r{<Table "ifTable">}) }
      it { is_expected.to contain_file('snmp_agent.load').with_content(%r{<Data "memAvailReal">}) }
      it { is_expected.to contain_file('snmp_agent.load').with_content(%r{OIDs "1.3.6.1.4.1.2021.4.6.0"}) }
    end
  end
end
