# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::turbostat', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf"
          )
        end
      end

      context ':ensure => present and :core_c_states => 392' do
        let :params do
          { core_c_states: 392 }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf",
            content: %r{CoreCstates "392"}m
          )
        end
      end

      context ':ensure => present and :package_c_states => 396' do
        let :params do
          { package_c_states: 396 }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf",
            content: %r{PackageCstates "396"}m
          )
        end
      end

      context ':ensure => present and :system_management_interrupt => false' do
        let :params do
          { system_management_interrupt: false }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf",
            content: %r{SystemManagementInterrupt "false"}m
          )
        end
      end

      context ':ensure => present and :digital_temperature_sensor => false' do
        let :params do
          { digital_temperature_sensor: false }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf",
            content: %r{DigitalTemperatureSensor "false"}m
          )
        end
      end

      context ':ensure => present and :logical_core_names => true and collectd 5.7' do
        let :facts do
          facts.merge(collectd_version: '5.7')
        end

        let :params do
          { logical_core_names: true }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf",
            content: %r{LogicalCoreNames "true"}m
          )
        end
      end

      context ':ensure => present and :tcc_activation_temp => 40' do
        let :params do
          { tcc_activation_temp: 40 }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf",
            content: %r{TCCActivationTemp "40"}m
          )
        end
      end

      context ':ensure => present and :running_average_power_limit => 8' do
        let :params do
          { running_average_power_limit: 8 }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-turbostat.conf" do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf",
            content: %r{RunningAveragePowerLimit "8"}m
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create /etc/collectd.d/10-turbostat.conf' do
          is_expected.to contain_file('turbostat.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-turbostat.conf"
          )
        end
      end
    end
  end
end
