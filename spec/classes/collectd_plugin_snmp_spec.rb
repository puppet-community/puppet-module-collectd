# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::snmp', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context ':ensure => present and dataset for AMAVIS-MIB::inMsgs.0' do
        let :params do
          {
            data: {
              'amavis_incoming_messages' => {
                'type'     => 'counter',
                'table'    => false,
                'instance' => 'amavis.inMsgs',
                'values'   => ['AMAVIS-MIB::inMsgs.0']
              }
            },
            hosts: {
              'scan04' => {
                'address'   => '127.0.0.1',
                'version'   => 2,
                'community' => 'public',
                'collect'   => ['amavis_incoming_messages'],
                'interval'  => 10
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-snmp.conf" do
          is_expected.to contain_file('snmp.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-snmp.conf",
            content: %r{Data "amavis_incoming_messages".+Instance "amavis.inMsgs".+Host "scan04".+Community "public"}m
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          {
            ensure: 'absent',
            data: {
              'amavis_incoming_messages' => {
                'type'     => 'counter',
                'table'    => false,
                'instance' => 'amavis.inMsgs',
                'values'   => ['AMAVIS-MIB::inMsgs.0']
              }
            },
            hosts: {
              'scan04' => {
                'address'   => '127.0.0.1',
                'version'   => 2,
                'community' => 'public',
                'collect'   => ['amavis_incoming_messages'],
                'interval'  => 10
              }
            }
          }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-snmp.conf" do
          is_expected.to contain_file('snmp.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-snmp.conf"
          )
        end
      end

      context 'SNMPv3' do
        let :params do
          {
            data: {
              'hc_octets' => {
                'type'     => 'if_octets',
                'table'    => true,
                'instance' => 'IF-MIB::ifName',
                'values'   => ['IF-MIB::ifHCInOctets', 'IF-MIB::ifHCOutOctets']
              }
            },
            hosts: {
              'router' => {
                'address'            => '192.0.2.1',
                'version'            => 3,
                'username'           => 'collectd',
                'security_level'     => 'authPriv',
                'auth_protocol'      => 'SHA',
                'auth_passphrase'    => 'mekmitasdigoat',
                'privacy_protocol'   => 'AES',
                'privacy_passphrase' => 'mekmitasdigoat',
                'collect'            => ['hc_octets'],
                'interval'           => 30
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-snmp.conf" do
          is_expected.to contain_file('snmp.load').with(ensure: 'present',
                                                        path: "#{options[:plugin_conf_dir]}/10-snmp.conf",
                                                        content: %r{Data "hc_octets".+Instance "IF-MIB::ifName".+Host "router".+Username "collectd".+SecurityLevel "authPriv".+AuthProtocol "SHA".+PrivacyProtocol "AES"}m)
        end
      end
    end
  end
end
