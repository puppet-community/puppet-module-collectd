# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::ceph', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context ':ensure => present and :daemons => [ \'ceph-osd.0\, \ceph-osd.1\, \ceph-osd.2\, \test-osd.0\, \ceph-mon.mon01\ ]' do
        let :params do
          { daemons: ['ceph-osd.0', 'ceph-osd.1', 'ceph-osd.2', 'test-osd.0', 'ceph-mon.mon01'] }
        end

        content = <<~EOS
          <Plugin ceph>
            LongRunAvgLatency false
            ConvertSpecialMetricTypes true

            <Daemon "ceph-osd.0">
              SocketPath "/var/run/ceph/ceph-osd.0.asok"
            </Daemon>
            <Daemon "ceph-osd.1">
              SocketPath "/var/run/ceph/ceph-osd.1.asok"
            </Daemon>
            <Daemon "ceph-osd.2">
              SocketPath "/var/run/ceph/ceph-osd.2.asok"
            </Daemon>
            <Daemon "test-osd.0">
              SocketPath "/var/run/ceph/test-osd.0.asok"
            </Daemon>
            <Daemon "ceph-mon.mon01">
              SocketPath "/var/run/ceph/ceph-mon.mon01.asok"
            </Daemon>

          </Plugin>
        EOS
        it "Will create #{options[:plugin_conf_dir]}/10-ceph.conf" do
          is_expected.to contain_collectd__plugin('ceph').with_content(content)
        end
      end

      context ':ensure => present and :daemons => [ \'ceph-osd.0\, \ceph-osd.1\, \ceph-mon.mon01\ ] and ceph_fsid => acd038fe-ce5c-5350-bfd2-0a2c17ad2c59' do
        let :params do
          {
            daemons: ['ceph-osd.0', 'ceph-osd.1', 'ceph-mon.mon01'],
            ceph_fsid: 'acd038fe-ce5c-5350-bfd2-0a2c17ad2c59'
          }
        end

        content = <<~EOS
          <Plugin ceph>
            LongRunAvgLatency false
            ConvertSpecialMetricTypes true

            <Daemon "ceph-osd.0">
              SocketPath "/var/run/ceph/acd038fe-ce5c-5350-bfd2-0a2c17ad2c59/ceph-osd.0.asok"
            </Daemon>
            <Daemon "ceph-osd.1">
              SocketPath "/var/run/ceph/acd038fe-ce5c-5350-bfd2-0a2c17ad2c59/ceph-osd.1.asok"
            </Daemon>
            <Daemon "ceph-mon.mon01">
              SocketPath "/var/run/ceph/acd038fe-ce5c-5350-bfd2-0a2c17ad2c59/ceph-mon.mon01.asok"
            </Daemon>

          </Plugin>
        EOS
        it "Will create #{options[:plugin_conf_dir]}/10-ceph.conf" do
          is_expected.to contain_collectd__plugin('ceph').with_content(content)
        end
      end

      context ':ensure => absent' do
        let :params do
          { daemons: ['ceph-osd.0', 'ceph-osd.1', 'ceph-osd.2'], ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-ceph.conf" do
          is_expected.to contain_file('ceph.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-ceph.conf"
          )
        end
      end

      context ':manage_package => true' do
        let :params do
          {
            manage_package: true,
            daemons: ['ceph-osd.0']
          }
        end

        it 'Will manage collectd-ceph' do
          is_expected.to contain_package('collectd-ceph').with(
            ensure: 'present',
            name: 'collectd-ceph'
          )
        end
      end

      context ':manage_package => false' do
        let :params do
          {
            manage_package: false,
            daemons: ['ceph-osd.0']
          }
        end

        it 'Will not manage collectd-ceph' do
          is_expected.not_to contain_package('collectd-ceph').with(
            ensure: 'present',
            name: 'collectd-ceph'
          )
        end
      end
    end
  end
end
