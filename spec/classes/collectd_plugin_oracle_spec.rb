# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::oracle', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      options = os_specific_options(facts)
      let :facts do
        facts
      end
      let(:config_filename) { "#{options[:plugin_conf_dir]}/15-oracle.conf" }

      context ':ensure => present, default host and port' do
        it "Will create #{options[:plugin_conf_dir]}/10-oracle.conf" do
          is_expected.to contain_file('oracle.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-oracle.conf",
            content: %r{LoadPlugin oracle}
          )
        end

        it "Will create #{options[:plugin_conf_dir]}/15-oracle.conf" do
          is_expected.to contain_concat(config_filename).with(
            ensure: 'present',
            path: config_filename
          )
        end

        it { is_expected.to contain_concat__fragment('collectd_plugin_oracle_conf_header').with_content(%r{<Plugin oracle>}) }
        it { is_expected.to contain_concat__fragment('collectd_plugin_oracle_conf_footer').with_content(%r{</Plugin>}) }
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-oracle.conf" do
          is_expected.to contain_file('oracle.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-oracle.conf"
          )
        end

        it "Will not create #{options[:plugin_conf_dir]}/15-oracle.conf" do
          is_expected.to contain_concat(config_filename).with(
            ensure: 'absent',
            path: config_filename
          )
        end
      end
    end
  end
end
