# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::iptables', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context ':ensure => present and :chains => { \'nat\' => \'In_SSH\' }' do
        let :params do
          { chains: { 'nat' => 'In_SSH' } }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-iptables.conf" do
          is_expected.to contain_file('iptables.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-iptables.conf",
            content: %r{Chain nat In_SSH}
          )
        end
      end

      context ':ensure => present and :chains6 => { \'filter\' => \'In6_SSH\' }' do
        let :params do
          { chains6: { 'filter' => 'In6_SSH' } }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-iptables.conf" do
          is_expected.to contain_file('iptables.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-iptables.conf",
            content: %r{Chain6 filter In6_SSH}
          )
        end
      end

      context ':ensure => present and :chains has two chains from the same table' do
        let :params do
          { chains: {
            'filter' => %w[INPUT OUTPUT]
          } }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-iptables.conf" do
          is_expected.to contain_file('iptables.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-iptables.conf",
            content: %r{Chain filter INPUT}
          )
          is_expected.to contain_file('iptables.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-iptables.conf",
            content: %r{Chain filter OUTPUT}
          )
        end
      end
    end
  end
end
