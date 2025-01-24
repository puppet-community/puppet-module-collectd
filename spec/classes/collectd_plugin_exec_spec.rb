# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::exec', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'single command' do
        let :params do
          {
            commands: { 'hello' =>
              {
                'user' => 'nobody',
                'group' => 'users',
                'exec' => ['/bin/echo', 'hello world']
              } }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/exec-config.conf" do
          is_expected.to contain_concat__fragment('collectd_plugin_exec_conf_header').with(
            content: %r{<Plugin exec>},
            target: "#{options[:plugin_conf_dir]}/exec-config.conf",
            order: '00'
          )
        end

        it "Will create #{options[:plugin_conf_dir]}/exec-config" do
          is_expected.to contain_concat("#{options[:plugin_conf_dir]}/exec-config.conf")
          is_expected.to contain_concat__fragment('collectd_plugin_exec_conf_footer').with(
            content: %r{</Plugin>},
            target: "#{options[:plugin_conf_dir]}/exec-config.conf",
            order: '99'
          )
        end

        it 'includes exec statement' do
          is_expected.to contain_concat__fragment('collectd_plugin_exec_conf_hello').with(
            content: %r{Exec "nobody:users" "/bin/echo" "hello world"},
            target: "#{options[:plugin_conf_dir]}/exec-config.conf"
          )
        end
      end

      context 'multiple commands' do
        let :params do
          {
            commands: {
              'hello' =>
                {
                  'user' => 'nobody',
                  'group' => 'users',
                  'exec' => ['/bin/echo', 'hello world']
                },
              'my_date' =>
                {
                  'user' => 'nobody',
                  'group' => 'users',
                  'exec' => ['/bin/date']
                }
            }
          }
        end

        it 'includes echo statement' do
          is_expected.to contain_concat__fragment('collectd_plugin_exec_conf_hello').with(
            content: %r{Exec "nobody:users" "/bin/echo" "hello world"},
            target: "#{options[:plugin_conf_dir]}/exec-config.conf"
          )
        end

        it 'includes date statement' do
          is_expected.to contain_concat__fragment('collectd_plugin_exec_conf_my_date').with(
            content: %r{Exec "nobody:users" "/bin/date"},
            target: "#{options[:plugin_conf_dir]}/exec-config.conf"
          )
        end
      end
    end
  end
end
