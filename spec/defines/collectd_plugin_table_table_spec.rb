# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::table::table' do
  let :title do
    '/proc/bar'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'Minimal attributes' do
        let :params do
          {
            'table' => {
              'results' => [{
                'type' => 'gauge',
                'values_from' => [0, 1]
              }, {
                'type' => 'counter',
                'values_from' => [2, 3]
              }]
            }
          }
        end

        it 'overrides defaults' do
          content = <<~EOS
            <Plugin "table">
              <Table "/proc/bar">
                <Result>
                  Type gauge
                  ValuesFrom 0 1
                </Result>
                <Result>
                  Type counter
                  ValuesFrom 2 3
                </Result>
              </Table>
            </Plugin>
          EOS

          is_expected.to compile.with_all_deps
          is_expected.to contain_class('collectd')
          is_expected.to contain_class('collectd::plugin::table')
          is_expected.to contain_file('table-/proc/bar.conf').with(
            content: content,
            path: "#{options[:plugin_conf_dir]}/10-tabletable-_proc_bar.conf"
          )
        end
      end

      context 'All attributes' do
        let :params do
          {
            'table' => {
              'plugin' => 'foo',
              'separator' => '_',
              'instance' => 'foo-metric',
              'results' => [{
                'type' => 'gauge',
                'values_from' => [0, 1],
                'instances_from' => [3, 4],
                'instance_prefix' => 'foo-'
              }]
            }
          }
        end

        it 'overrides defaults' do
          content = <<~EOS
            <Plugin "table">
              <Table "/proc/bar">
                Plugin "foo"
                Separator "_"
                Instance "foo-metric"
                <Result>
                  Type gauge
                  InstancePrefix "foo-"
                  InstancesFrom 3 4
                  ValuesFrom 0 1
                </Result>
              </Table>
            </Plugin>
          EOS

          is_expected.to compile.with_all_deps
          is_expected.to contain_class('collectd')
          is_expected.to contain_file('table-/proc/bar.conf').with(
            content: content,
            path: "#{options[:plugin_conf_dir]}/10-tabletable-_proc_bar.conf"
          )
        end
      end
    end
  end
end
