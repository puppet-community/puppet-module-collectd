# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::python::module', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'spam module' do
        let(:title) { 'spam' }
        let :params do
          {
            config: [{ 'spam' => %w[wonderful lovely] }],
            modulepath: '/var/lib/collectd/python'
          }
        end

        it 'imports spam module' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_spam_header').with(
            content: %r{Import "spam"},
            target: "#{options[:plugin_conf_dir]}/python-config.conf"
          )
        end

        it 'includes spam module configuration' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_spam_config').with(
            content: %r{<Module "spam">},
            target: "#{options[:plugin_conf_dir]}/python-config.conf"
          )

          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_spam_config').with(
            content: %r{spam "wonderful" "lovely"}
          )
        end

        it "Will create #{options[:plugin_conf_dir]}python-config.conf" do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
            content: %r{<Plugin "python">},
            target: "#{options[:plugin_conf_dir]}/python-config.conf",
            order: '00'
          )
        end

        it 'set default Python module path' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
            content: %r{ModulePath "/usr/local/lib/python2.7/dist-packages"},
            target: "#{options[:plugin_conf_dir]}/python-config.conf"
          )
        end

        it "Will create #{options[:plugin_conf_dir]}/python-config.conf" do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_footer').with(
            content: %r{</Plugin>},
            target: "#{options[:plugin_conf_dir]}/python-config.conf",
            order: '99'
          )
        end
      end

      context 'module without modulepath' do
        let(:title) { 'foo' }
        let :params do
          {
            script_source: 'puppet:///modules/myorg/foo.py',
            config: [{ 'bar' => 'baz' }]
          }
        end

        it 'imports foo module' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_header').with(
            content: %r{Import "foo"},
            target: "#{options[:plugin_conf_dir]}/python-config.conf"
          )
        end

        it 'includes foo module configuration' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(
            content: %r{<Module "foo">},
            target: "#{options[:plugin_conf_dir]}/python-config.conf"
          )
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(content: %r{bar "baz"})
        end

        it 'closes the module foo' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(
            content: %r{</Module>},
            target: "#{options[:plugin_conf_dir]}/python-config.conf"
          )
        end

        it 'created collectd plugin file on Debian default path' do
          is_expected.to contain_file('foo.script').with(
            ensure: 'present',
            path: '/usr/local/lib/python2.7/dist-packages/foo.py'
          )
        end
      end

      context 'complex config' do
        let(:title) { 'foo' }
        let :params do
          {
            config: [{ 'k1' => 'v1', 'k2' => %w[v21 v22] }]
          }
        end

        it 'includes foo module configuration' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(content: %r{k1 "v1"})
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(content: %r{k2 "v21" "v22"})
        end
      end
    end
  end
end
