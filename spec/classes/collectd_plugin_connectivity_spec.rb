# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::connectivity', type: :class do
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
        it { is_expected.to contain_collectd__plugin('connectivity') }
        it { is_expected.to contain_file('old_connectivity.load').with_ensure('absent') }
        it { is_expected.to contain_file('older_connectivity.load').with_ensure('absent') }

        it 'Will create 10-connectivity.conf' do
          is_expected.to contain_file('connectivity.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-connectivity.conf"
          )
        end

        it { is_expected.to contain_file('connectivity.load').with(content: %r{<Plugin connectivity>}) }
      end

      context 'overriding default parameters' do
        let(:params) do
          { ensure: 'present',
            interfaces: %w[eth0 eth1] }
        end

        it { is_expected.to contain_file('connectivity.load').with(content: %r{Interface "eth0"}) }
        it { is_expected.to contain_file('connectivity.load').with(content: %r{Interface "eth1"}) }
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-connectivity.conf' do
          is_expected.to contain_file('connectivity.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-connectivity.conf"
          )
        end
      end
    end
  end
end
