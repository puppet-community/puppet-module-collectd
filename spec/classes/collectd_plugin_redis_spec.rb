# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::redis', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-redis.conf" do
          is_expected.to contain_file('redis.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-redis.conf"
          )
        end
      end

      context ':ensure => present, password => "testpassword"' do
        let :params do
          {
            nodes: {
              'redis' => {
                'host' => 'localhost',
                'port' => '6379',
                'password' => 'testpassword',
                'timeout' => 2000
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-redis.conf with password" do
          is_expected.to contain_file('redis.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-redis.conf"
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create /etc/collectd.d/10-redis.conf' do
          is_expected.to contain_file('redis.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-redis.conf"
          )
        end
      end
    end
  end
end
