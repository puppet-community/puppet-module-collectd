# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::powerdns', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        context ':ensure => present and default parameters' do
          it "Will create #{options[:plugin_conf_dir]}/10-powerdns.conf to load the plugin" do
            is_expected.to contain_file('powerdns.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-powerdns.conf",
              content: %r{LoadPlugin powerdns}
            )
          end

          it "Will create #{options[:plugin_conf_dir]}/powerdns-config.conf" do
            is_expected.to contain_concat("#{options[:plugin_conf_dir]}/powerdns-config.conf")
            is_expected.to contain_concat__fragment('collectd_plugin_powerdns_conf_header').with(
              content: "<Plugin \"powerdns\">\n",
              target: "#{options[:plugin_conf_dir]}/powerdns-config.conf",
              order: '00'
            )
          end

          it "Will create #{options[:plugin_conf_dir]}/powerdns-config.conf" do
            is_expected.to contain_concat__fragment('collectd_plugin_powerdns_conf_footer').with(
              content: %r{</Plugin>},
              target: "#{options[:plugin_conf_dir]}/powerdns-config.conf",
              order: '99'
            )
          end
        end

        context ':ensure => present and overrided parameters' do
          let :params do
            {
              local_socket: '/var/run/whatever',
              servers: {
                one: {
                  collect: %w[latency recursing-answers recursing-questions],
                  socket: '/var/run/server1.sock'
                },
                two: {}
              },
              recursors: {
                three: {
                  collect: %w[cache-hits cache-misses],
                  socket: '/var/run/server3.sock'
                },
                four: {}
              }
            }
          end

          it "Will create #{options[:plugin_conf_dir]}/powerdns-config.conf" do
            is_expected.to contain_concat("#{options[:plugin_conf_dir]}/powerdns-config.conf")
            is_expected.to contain_concat__fragment('collectd_plugin_powerdns_conf_header').with(
              content: "<Plugin \"powerdns\">
  LocalSocket \"/var/run/whatever\"
",
              target: "#{options[:plugin_conf_dir]}/powerdns-config.conf",
              order: '00'
            )
            is_expected.to contain_concat__fragment('collectd_plugin_powerdns_conf_server_one').with(
              content: "  <Server \"one\">
    Collect \"latency\"
    Collect \"recursing-answers\"
    Collect \"recursing-questions\"
    Socket \"/var/run/server1.sock\"
  </Server>
",
              target: "#{options[:plugin_conf_dir]}/powerdns-config.conf",
              order: '50'
            )
            is_expected.to contain_concat__fragment('collectd_plugin_powerdns_conf_server_two').with(
              content: "  <Server \"two\">
  </Server>
",
              target: "#{options[:plugin_conf_dir]}/powerdns-config.conf",
              order: '50'
            )

            is_expected.to contain_concat__fragment('collectd_plugin_powerdns_conf_recursor_three').with(
              content: "  <Recursor \"three\">
    Collect \"cache-hits\"
    Collect \"cache-misses\"
    Socket \"/var/run/server3.sock\"
  </Recursor>
",
              target: "#{options[:plugin_conf_dir]}/powerdns-config.conf",
              order: '51'
            )
            is_expected.to contain_concat__fragment('collectd_plugin_powerdns_conf_recursor_four').with(
              content: "  <Recursor \"four\">
  </Recursor>
",
              target: "#{options[:plugin_conf_dir]}/powerdns-config.conf",
              order: '51'
            )
          end
        end
      end
    end
  end
end
