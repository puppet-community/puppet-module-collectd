# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::memcached', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)

      context ':ensure => present, default host, address, and port' do
        it "Will create #{options[:plugin_conf_dir]}/memcached.conf" do
          content = <<EOS
  <Instance "default">
    Host "localhost"
    Address "127.0.0.1"
    Port 11211
  </Instance>
EOS
          is_expected.to contain_file('memcached.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-memcached.conf",
            content: %r{#{content}}
          )
        end
      end

      context ':ensure => present, multiple ports' do
        let :params do
          {
            'instances' => {
              'sessions1' => {
                'host' => 'localhost',
                'address' => '127.0.0.1',
                'port' => '11211'
              },
              'cache1' => {
                'host' => 'localhost',
                'port' => '11212'
              },
              'cache3' => {
                'address' => '127.0.0.1',
                'port' => '11213'
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/memcached.conf" do
          content = <<EOS
  <Instance "sessions1">
    Host "localhost"
    Address "127.0.0.1"
    Port 11211
  </Instance>
  <Instance "cache1">
    Host "localhost"
    Port 11212
  </Instance>
  <Instance "cache3">
    Address "127.0.0.1"
    Port 11213
  </Instance>
EOS
          is_expected.to contain_file('memcached.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-memcached.conf",
            content: %r{#{content}}
          )
        end
      end

      context ':ensure => present, multiple sockets' do
        let :params do
          {
            'instances' => {
              'sessions2' => {
                'socket' => '/var/run/memcached.sessions.sock'
              },
              'cache2' => {
                'socket' => '/var/run/memcached.cache.sock'
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/memcached.conf" do
          content = <<EOS
  <Instance "sessions2">
    Socket "/var/run/memcached.sessions.sock"
  </Instance>
  <Instance "cache2">
    Socket "/var/run/memcached.cache.sock"
  </Instance>
EOS
          is_expected.to contain_file('memcached.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-memcached.conf",
            content: %r{#{content}}
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/memcached.conf" do
          is_expected.to contain_file('memcached.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-memcached.conf"
          )
        end
      end
    end
  end
end
