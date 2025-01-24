# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::ipmi', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      options = os_specific_options(facts)
      let :facts do
        facts
      end
      let :pre_condition do
        'include collectd'
      end

      context ':ensure => present, default params and legacy collectd 5.4' do
        it "Will create #{options[:plugin_conf_dir]}/10-ipmi.conf" do
          is_expected.to contain_file('ipmi.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-ipmi.conf"
          )
        end
      end

      context ':sensors param is not an array' do
        let :params do
          { sensors: true }
        end

        it 'Will raise an error about :sensors not being an array' do
          is_expected.not_to compile
        end
      end

      context ':notify_sensor_not_present is not a bool' do
        let :params do
          { notify_sensor_not_present: 'true' }
        end

        it 'Will raise an error about :notify_sensor_not_present not being a boolean' do
          is_expected.to compile.and_raise_error(%r{"true" is not a boolean.  It looks to be a String})
        end
      end

      context ':notify_sensor_remove is not a bool' do
        let :params do
          { notify_sensor_remove: 'true' }
        end

        it 'Will raise an error about :notify_sensor_remove not being a boolean' do
          is_expected.to compile.and_raise_error(%r{"true" is not a boolean.  It looks to be a String})
        end
      end

      context ':notify_sensor_add is not a bool' do
        let :params do
          { notify_sensor_add: 'true' }
        end

        it 'Will raise an error about :notify_sensor_add not being a boolean' do
          is_expected.to compile.and_raise_error(%r{"true" is not a boolean.  It looks to be a String})
        end
      end

      context ':ignore_selected is not a bool' do
        let :params do
          { ignore_selected: 'true' }
        end

        it 'Will raise an error about :ignore_selected not being a boolean' do
          is_expected.to compile.and_raise_error(%r{"true" is not a boolean.  It looks to be a String})
        end
      end

      context ':interval is not default and is an integer' do
        let :params do
          { interval: 15 }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-ipmi.conf" do
          is_expected.to contain_file('ipmi.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-ipmi.conf",
            content: %r{^  Interval 15}
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-ipmi.conf" do
          is_expected.to contain_file('ipmi.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-ipmi.conf"
          )
        end
      end
    end
  end
end
