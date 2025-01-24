# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::write_prometheus', type: :class do
  ip = '192.0.0.1'
  port = 9103
  host_opt_min_collectd_ver = '5.9'
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge(collectd_version: '5.7')
      end

      options = os_specific_options(facts)
      context ":ensure => present and :port => #{port} and ip => #{ip}" do
        let :params do
          {
            port: port,
            ip: ip,
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-write_prometheus.conf without Host" do
          is_expected.to contain_file('write_prometheus.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-write_prometheus.conf",
            content: %r{Port "#{port}"}
          ).without(
            content: %r{Host "#{ip}"}
          )
        end

        context "Will include hostname if version is >= #{host_opt_min_collectd_ver}" do
          let :facts do
            facts.merge(collectd_version: host_opt_min_collectd_ver)
          end

          it "Will create #{options[:plugin_conf_dir]}/10-write_prometheus.conf with Host" do
            is_expected.to contain_file('write_prometheus.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-write_prometheus.conf",
              content: %r{Port "#{port}"}
            ).with(
              content: %r{Host "#{ip}"}
            )
          end
        end

        context "Will NOT include hostname if not specified even if version is >= #{host_opt_min_collectd_ver}" do
          let :params do
            { port: 9103 }
          end

          let :facts do
            facts.merge(collectd_version: host_opt_min_collectd_ver)
          end

          it "Will create #{options[:plugin_conf_dir]}/10-write_prometheus.conf without Host" do
            is_expected.to contain_file('write_prometheus.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-write_prometheus.conf",
              content: %r{Port "#{port}"}
            ).without(
              content: %r{Host "#{ip}"}
            )
          end
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create' do
          is_expected.to contain_file('write_prometheus.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-write_prometheus.conf"
          )
        end
      end
    end
  end
end
