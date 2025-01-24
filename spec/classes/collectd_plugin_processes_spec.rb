# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::processes', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        context ':ensure => present and default parameters' do
          it "Will create #{options[:plugin_conf_dir]}/10-processes.conf to load the plugin" do
            is_expected.to contain_file('processes.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-processes.conf",
              content: %r{LoadPlugin processes}
            )
          end

          it "Will create #{options[:plugin_conf_dir]}/processes_config.conf" do
            is_expected.to contain_concat("#{options[:plugin_conf_dir]}/processes_config.conf")
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_header').with(
              content: "<Plugin processes>\n",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '00'
            )
          end

          it "Will create #{options[:plugin_conf_dir]}/processes_config.conf" do
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_footer').with(
              content: %r{</Plugin>},
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '99'
            )
          end
        end

        context ':ensure => present and overrided parameters' do
          let :params do
            {
              collect_context_switch: true,
              collect_file_descriptor: false,
              collect_memory_maps: true,
              processes: [
                {
                  name: 'httpd',
                  collect_context_switch: false,
                  collect_file_descriptor: true,
                  collect_memory_maps: false
                },
                'mysql'
              ],
              process_matches: [
                {
                  name: 'post',
                  regex: 'post.*',
                  collect_context_switch: false,
                  collect_file_descriptor: true,
                  collect_memory_maps: false
                },
                {
                  name: 'dove',
                  regex: 'dove.*'
                }
              ]
            }
          end

          it "Will create #{options[:plugin_conf_dir]}/processes_config.conf" do
            is_expected.to contain_concat("#{options[:plugin_conf_dir]}/processes_config.conf")
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_header').with(
              content: "<Plugin processes>
  CollectContextSwitch true
  CollectFileDescriptor false
  CollectMemoryMaps true
",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '00'
            )
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_process_httpd').with(
              content: "  <Process \"httpd\">
    CollectContextSwitch false
    CollectFileDescriptor true
    CollectMemoryMaps false
  </Process>
",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '50'
            )
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_process_mysql').with(
              content: "  <Process \"mysql\">
  </Process>
",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '50'
            )

            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_processmatch_post').with(
              content: "  <ProcessMatch \"post\" \"post.*\">
    CollectContextSwitch false
    CollectFileDescriptor true
    CollectMemoryMaps false
  </ProcessMatch>
",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '51'
            )
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_processmatch_dove').with(
              content: "  <ProcessMatch \"dove\" \"dove.*\">
  </ProcessMatch>
",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '51'
            )
          end
        end

        context ':ensure => present and overrided parameters backward compat for process' do
          let :params do
            {
              processes: %w[process1 process2]
            }
          end

          it "Will create #{options[:plugin_conf_dir]}/processes_config.conf" do
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_process_process1').with(
              content: "  <Process \"process1\">
  </Process>
",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '50'
            )
            is_expected.to contain_concat__fragment('collectd_plugin_processes_conf_process_process2').with(
              content: "  <Process \"process2\">
  </Process>
",
              target: "#{options[:plugin_conf_dir]}/processes_config.conf",
              order: '50'
            )
          end
        end

        case facts['os']['family']
        when 'RedHat'
          context 'on osfamily => RedHat' do
            it 'Will delete packaging config file' do
              is_expected.to contain_file('package_processes.load').with_ensure('absent')
              is_expected.to contain_file('package_processes.load').with_path('/etc/collectd.d/processes-config.conf')
            end

            it 'Will not clash with package file' do
              is_expected.not_to contain_concat('/etc/collectd.d/processes-config.conf')
            end
          end
        end
      end
    end
  end
end
