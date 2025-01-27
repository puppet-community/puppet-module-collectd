# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::modbus' do
  on_supported_os(baseline_os_hash).each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end
      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(os_facts)

      context ':ensure => present and dataset for Current Phase A' do
        let :params do
          {
            data: {
              'current_phase_a' => {
                'type'          => 'gauge',
                'instance'      => 'Current Phase A',
                'register_base' => 1234,
                'register_type' => 'Float',
              }
            },
            hosts: {
              'power123' => {
                'address' => '127.0.0.1',
                'port' => 502,
                'interval' => 10,
                'slaves' => {
                  255 => {
                    'instance' => 'power meter 255',
                    'collect' => ['current_phase_a'],
                  }
                }
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-modbus.conf" do
          is_expected.to contain_file('modbus.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-modbus.conf",
            content: %r{Data "current_phase_a".+Instance "Current Phase A".+Host "power123".+Slave 255}m
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          {
            ensure: 'absent',
            data: {
              'current_phase_a' => {
                'type'          => 'gauge',
                'instance'      => 'Current Phase A',
                'register_base' => 1234,
                'register_type' => 'Float',
              }
            },
            hosts: {
              'power123' => {
                'address' => '127.0.0.1',
                'port' => 502,
                'interval' => 10,
                'slaves' => {
                  255 => {
                    'instance' => 'power meter 255',
                    'collect' => ['current_phase_a'],
                  }
                }
              }
            }
          }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-modbus.conf" do
          is_expected.to contain_file('modbus.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-modbus.conf"
          )
        end
      end
    end
  end
end
