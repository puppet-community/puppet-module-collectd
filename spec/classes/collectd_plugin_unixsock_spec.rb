# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::unixsock', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and default parameters' do
        it 'Will create /etc/collectd.d/10-unixsock.conf' do
          is_expected.to contain_file('unixsock.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-unixsock.conf",
            content: %r{SocketFile  "/var/run/collectd-unixsock".+SocketGroup "collectd".+SocketPerms "0770"}m
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create /etc/collectd.d/10-unixsock.conf' do
          is_expected.to contain_file('unixsock.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-unixsock.conf"
          )
        end
      end
    end
  end
end
