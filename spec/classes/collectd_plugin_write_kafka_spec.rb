# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::write_kafka', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and :kafka_host => \'myhost\'' do
        let :params do
          { kafka_host: 'myhost', kafka_port: 9092, topics: { 'my-topic' => { 'format' => 'JSON' } }, properties: { 'my-property' => 'my-value' }, meta: { 'my-meta' => 'my-value' } }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-write_kafka.conf" do
          is_expected.to contain_file('write_kafka.load').with(ensure: 'present')
          is_expected.to contain_file('write_kafka.load').with(path: "#{options[:plugin_conf_dir]}/10-write_kafka.conf")
          is_expected.to contain_file('write_kafka.load').with(content: %r{Property "metadata.broker.list" "myhost:9092"})
          is_expected.to contain_file('write_kafka.load').with(content: %r{Property "my-property" "my-value"})
          is_expected.to contain_file('write_kafka.load').with(content: %r{Topic "my-topic"})
          is_expected.to contain_file('write_kafka.load').with(content: %r{Format "JSON"})
          is_expected.to contain_file('write_kafka.load').with(content: %r{Meta "my-meta" "my-value"})
        end
      end

      context ':ensure => absent' do
        let :params do
          { kafka_host: ['myhost'], ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-write_kafka.conf" do
          is_expected.to contain_file('write_kafka.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-write_kafka.conf"
          )
        end
      end
    end
  end
end
