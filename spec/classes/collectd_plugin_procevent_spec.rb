# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::procevent', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        let :params do
          { ensure: 'present' }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_collectd__plugin('procevent') }
        it { is_expected.to contain_file('old_procevent.load').with_ensure('absent') }
        it { is_expected.to contain_file('older_procevent.load').with_ensure('absent') }

        it 'Will create 10-procevent.conf' do
          is_expected.to contain_file('procevent.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-procevent.conf"
          )
        end

        it { is_expected.to contain_file('procevent.load').with(content: %r{<Plugin procevent>}) }
      end

      context 'overriding default parameters' do
        let(:params) do
          { ensure: 'present',
            process: 'foo',
            process_regex: '/bar/',
            buffer_length: 10 }
        end

        it { is_expected.to contain_file('procevent.load').with(content: %r{Process "foo"}) }
        it { is_expected.to contain_file('procevent.load').with(content: %r{ProcessRegex "/bar/"}) }
        it { is_expected.to contain_file('procevent.load').with(content: %r{BufferLength 10}) }
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-procevent.conf' do
          is_expected.to contain_file('procevent.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-procevent.conf"
          )
        end
      end
    end
  end
end
