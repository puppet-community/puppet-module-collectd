# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::exec::cmd', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'define a command' do
        let(:title) { 'whoami' }
        let :params do
          {
            user: 'www-data',
            group: 'users',
            exec: ['whoami', '--help']
          }
        end

        it 'executes whoami command' do
          is_expected.to contain_concat__fragment('collectd_plugin_exec_conf_whoami').with(
            content: %r{Exec "www-data:users" "whoami" "--help"},
            target: "#{options[:plugin_conf_dir]}/exec-config.conf"
          )
        end
      end

      context 'define a notification' do
        let(:title) { 'whoami' }
        let :params do
          {
            user: 'www-data',
            group: 'users',
            notification_exec: ['whoami', '--help']
          }
        end

        it 'executes whoami command' do
          is_expected.to contain_concat__fragment('collectd_plugin_exec_conf_whoami').with(
            content: %r{NotificationExec "www-data:users" "whoami" "--help"},
            target: "#{options[:plugin_conf_dir]}/exec-config.conf"
          )
        end
      end
    end
  end
end
