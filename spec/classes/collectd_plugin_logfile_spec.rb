# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::logfile', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/05-logfile.conf" do
          is_expected.to contain_file('logfile.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/05-logfile.conf"
          )
        end
      end

      context ':ensure => present, specific params, collectd version 4.9' do
        let :facts do
          facts.merge(collectd_version: '4.9')
        end
        let :params do
          { print_severity: true }
        end

        it "Will create #{options[:plugin_conf_dir]}/05-logfile.conf for collectd < 4.10" do
          is_expected.to contain_file('logfile.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/05-logfile.conf"
          ).without_content(%r{PrintSeverity})
        end
      end

      context ':ensure => present, default params, collectd version 4.10' do
        it "Will create #{options[:plugin_conf_dir]}/05-logfile.conf for collectd >= 4.10" do
          is_expected.to contain_file('logfile.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/05-logfile.conf",
            content: %r{PrintSeverity false}
          )
        end
      end

      context ':ensure => present, specific params, collectd version 4.10' do
        let :params do
          { print_severity: true }
        end

        it "Will create #{options[:plugin_conf_dir]}05-logfile.conf for collectd >= 4.10" do
          is_expected.to contain_file('logfile.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/05-logfile.conf",
            content: %r{PrintSeverity true}
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/05-logfile.conf" do
          is_expected.to contain_file('logfile.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/05-logfile.conf"
          )
        end
      end
    end
  end
end
