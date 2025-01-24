# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::zookeeper', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)

      context ":ensure => present and :zookeeper_host => 'myhost'" do
        let :params do
          { zookeeper_host: 'myhost', zookeeper_port: 2181 }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-zookeeper.load" do
          is_expected.to contain_file('zookeeper.load').with(ensure: 'present')
          is_expected.to contain_file('zookeeper.load').with(path: "#{options[:plugin_conf_dir]}/10-zookeeper.conf")
          is_expected.to contain_file('zookeeper.load').with(content: %r{Host "myhost"})
          is_expected.to contain_file('zookeeper.load').with(content: %r{Port "2181"})
        end
      end

      context ':ensure => absent' do
        let :params do
          { zookeeper_host: 'myhost', ensure: 'absent' }
        end

        it 'Will not create' do
          is_expected.to contain_file('zookeeper.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-zookeeper.conf"
          )
        end
      end
    end
  end
end
