# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::tcpconns', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and :localports => [22,25]' do
        let :params do
          { localports: [22, 25] }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-tcpconns.conf" do
          is_expected.to contain_file('tcpconns.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-tcpconns.conf",
            content: %r{LocalPort "22".+LocalPort "25"}m
          )
        end
      end

      context ':ensure => present, :localports => [22,25] and :remoteports => [3306]' do
        let :params do
          { localports: [22, 25], remoteports: [3306] }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-tcpconns.conf" do
          is_expected.to contain_file('tcpconns.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-tcpconns.conf",
            content: %r{LocalPort "22".+LocalPort "25".+RemotePort "3306"}m
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { localports: [22], ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-tcpconns.conf" do
          is_expected.to contain_file('tcpconns.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-tcpconns.conf"
          )
        end
      end

      context ':localports is not an array' do
        let :params do
          { localports: '22' }
        end

        it 'Will raise an error about :localports being a String' do
          is_expected.to compile.and_raise_error(%r{String})
        end
      end

      context ':remoteports is not an array' do
        let :params do
          { remoteports: '22' }
        end

        it 'Will raise an error about :remoteports being a String' do
          is_expected.to compile.and_raise_error(%r{String})
        end
      end

      context ':allportssummary is not a boolean' do
        let :params do
          { allportssummary: 'aString' }
        end

        it 'Will raise an error about :allportssummary being a String' do
          is_expected.to compile.and_raise_error(%r{String})
        end
      end

      context ':allportssummary => true with collectd_version < 5.5.0' do
        let :facts do
          facts.merge(collectd_version: '5.4.1')
        end
        let :params do
          { ensure: 'present', allportssummary: true }
        end

        it 'does not include AllPortsSummary in /etc/collectd.d/10-tcpconns.conf' do
          is_expected.to contain_file('tcpconns.load').without_content(%r{AllPortsSummary})
        end
      end

      context ':allportssummary => true with collectd_version = 5.5.0' do
        let :facts do
          facts.merge(collectd_version: '5.5.0')
        end
        let :params do
          { ensure: 'present', allportssummary: true }
        end

        it 'includes AllPortsSummary in /etc/collectd.d/10-tcpconns.conf' do
          is_expected.to contain_file('tcpconns.load').with_content(%r{AllPortsSummary true})
        end
      end
    end
  end
end
