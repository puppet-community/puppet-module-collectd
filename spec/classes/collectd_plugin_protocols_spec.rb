# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::protocols', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        it 'Will create /etc/collectd.d/10-protocols.conf' do
          is_expected.to contain_file('protocols.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-protocols.conf",
            content: %r{}
          )
        end
      end

      context ':ensure => present, specific params' do
        let :params do
          { values: %w[protocol1 protocol2] }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-protocols.conf" do
          is_expected.to contain_file('protocols.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-protocols.conf",
            content: %r{<Plugin "protocols">\n\s*Value "protocol1"\n\s*Value "protocol2"\n</Plugin>}
          )
        end
      end

      describe 'ignoreselected' do
        context ':ignoreselected => false' do
          let :params do
            {
              values: %w[protocol1 protocol2],
              ignoreselected: false
            }
          end

          it { is_expected.to contain_file('protocols.load').with_content(%r{<Plugin "protocols">\n\s*Value "protocol1"\n\s*Value "protocol2"\n\s*IgnoreSelected false\n</Plugin>}) }
        end

        context ':ignoreselected => true' do
          let :params do
            {
              values: %w[protocol1 protocol2],
              ignoreselected: true
            }
          end

          it { is_expected.to contain_file('protocols.load').with_content(%r{<Plugin "protocols">\n\s*Value "protocol1"\n\s*Value "protocol2"\n\s*IgnoreSelected true\n</Plugin>}) }
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-protocols.conf" do
          is_expected.to contain_file('protocols.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-protocols.conf"
          )
        end
      end
    end
  end
end
