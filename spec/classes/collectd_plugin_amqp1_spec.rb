# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::amqp1', type: :class do
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
        it { is_expected.to contain_collectd__plugin('amqp1') }
        it { is_expected.to contain_file('old_amqp1.load').with_ensure('absent') }
        it { is_expected.to contain_file('older_amqp1.load').with_ensure('absent') }

        it 'Will create 10-amqp1.conf' do
          is_expected.to contain_file('amqp1.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-amqp1.conf"
          )
        end

        it { is_expected.to contain_file('amqp1.load').with(content: %r{<Transport "metrics">}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Host "localhost"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Port "5672"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{User "guest"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Password "guest"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Address "collectd"}) }
      end

      context 'overriding default parameters' do
        let(:params) do
          { ensure: 'present',
            transport: 'transport',
            host: 'host',
            port: 666,
            user: 'user',
            password: 'password',
            address: 'address',
            retry_delay: 30,
            send_queue_limit: 40,
            instances: {
              instance: {
                format: 'JSON',
                presettle: true,
                notify: false,
                store_rates: false,
                graphite_prefix: 'test',
                graphite_postfix: 'test',
                graphite_escape_char: '_',
                graphite_separate_instances: false,
                graphite_always_append_ds: false,
                graphite_preserve_separator: false
              }
            } }
        end

        it { is_expected.to contain_file('amqp1.load').with(content: %r{<Transport "transport">}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Host "host"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Port "666"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{User "user"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Password "password"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Address "address"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{RetryDelay 30}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{SendQueueLimit 40}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{<Instance "instance">}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Format "JSON"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{PreSettle true}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{Notify false}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{StoreRates false}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{GraphitePrefix "test"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{GraphitePostfix "test"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{GraphiteEscapeChar "_"}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{GraphiteSeparateInstances false}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{GraphiteAlwaysAppendDS false}) }
        it { is_expected.to contain_file('amqp1.load').with(content: %r{GraphitePreserveSeparator false}) }
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-amqp1.conf' do
          is_expected.to contain_file('amqp1.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-amqp1.conf"
          )
        end
      end
    end
  end
end
