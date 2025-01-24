# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::sysevent', type: :class do
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
        it { is_expected.to contain_collectd__plugin('sysevent') }
        it { is_expected.to contain_file('old_sysevent.load').with_ensure('absent') }
        it { is_expected.to contain_file('older_sysevent.load').with_ensure('absent') }

        it 'Will create 10-sysevent.conf' do
          is_expected.to contain_file('sysevent.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-sysevent.conf"
          )
        end

        it { is_expected.to contain_file('sysevent.load').with(content: %r{Listen "127.0.0.1" "6666"}) }
        it { is_expected.to contain_file('sysevent.load').with(content: %r{RegexFilter "/.*/"}) }
      end

      context 'overriding default parameters' do
        let(:params) do
          { ensure: 'present',
            listen_host: '1.2.3.4',
            listen_port: 1234,
            regex_filter: '/foobar/',
            buffer_size: 4096,
            buffer_length: 10 }
        end

        it { is_expected.to contain_file('sysevent.load').with(content: %r{Listen "1.2.3.4" "1234"}) }
        it { is_expected.to contain_file('sysevent.load').with(content: %r{RegexFilter "/foobar/"}) }
        it { is_expected.to contain_file('sysevent.load').with(content: %r{BufferSize 4096}) }
        it { is_expected.to contain_file('sysevent.load').with(content: %r{BufferLength 10}) }
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-sysevent.conf' do
          is_expected.to contain_file('sysevent.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-sysevent.conf"
          )
        end
      end
    end
  end
end
