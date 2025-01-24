# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::amqp', type: :class do
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

        it { is_expected.to contain_collectd__plugin('amqp') }
        it { is_expected.to contain_file('old_amqp.load').with_ensure('absent') }
        it { is_expected.to contain_file('older_amqp.load').with_ensure('absent') }

        it 'Will create 10-amqp.conf' do
          is_expected.to contain_file('amqp.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-amqp.conf"
          )
        end

        it { is_expected.to contain_file('amqp.load').with(content: %r{<Publish "graphite">}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Host "localhost"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Port "5672"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{VHost "graphite"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{User "graphite"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Password "graphite"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Format "Graphite"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{StoreRates false}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Exchange "metrics"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Persistent true}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{GraphitePrefix "collectd."}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{GraphiteEscapeChar "_"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{</Publish>}) }
      end

      context 'overriding default parameters' do
        let(:params) do
          { amqphost: 'myhost',
            amqpport: 5666,
            amqpvhost: 'amqp',
            amqpuser: 'user',
            amqppass: 'pass',
            amqpformat: 'JSON',
            amqpstorerates: true,
            amqpexchange: 'ex',
            amqppersistent: false,
            graphiteprefix: 'prefix',
            escapecharacter: '|',
            graphiteseparateinstances: true,
            graphitealwaysappendds: true }
        end

        it { is_expected.to contain_file('amqp.load').with(content: %r{<Publish "graphite">}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Host "myhost"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Port "5666"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{VHost "amqp"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{User "user"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Password "pass"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Format "JSON"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{StoreRates true}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Exchange "ex"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{Persistent false}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{GraphitePrefix "prefix"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{GraphiteEscapeChar "\|"}) }
        it { is_expected.to contain_file('amqp.load').with(content: %r{</Publish>}) }

        context 'with collectd 5.5+' do
          let :facts do
            facts.merge(collectd_version: '5.6.0')
          end

          it { is_expected.to contain_file('amqp.load').with(content: %r{GraphiteSeparateInstances true}) }
          it { is_expected.to contain_file('amqp.load').with(content: %r{GraphiteAlwaysAppendDS true}) }
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-amqp.conf' do
          is_expected.to contain_file('amqp.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-amqp.conf"
          )
        end
      end
    end
  end
end
