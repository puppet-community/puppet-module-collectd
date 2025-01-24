# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::rrdtool', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default args' do
        it 'Will create /etc/collectd.d/10-rrdtool.conf' do
          is_expected.to contain_file('rrdtool.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-rrdtool.conf",
            content: %r{DataDir "/var/lib/collectd/rrd}
          )
        end

        case facts['os']['family']
        when 'RedHat'

          it { is_expected.to contain_package('collectd-rrdtool').with(ensure: 'present') }
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-rrdtool.conf" do
          is_expected.to contain_file('rrdtool.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-rrdtool.conf"
          )
        end
      end
    end
  end
end
