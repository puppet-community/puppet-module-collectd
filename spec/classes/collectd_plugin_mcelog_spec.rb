# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::mcelog', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include collectd'
      end

      it { is_expected.to compile.with_all_deps }

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-mcelog.conf" do
          is_expected.to contain_file('mcelog.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-mcelog.conf"
          )
        end

        it { is_expected.to contain_file('mcelog.load').with(content: %r{<Memory>}) }
        it { is_expected.to contain_file('mcelog.load').with(content: %r{McelogClientSocket "/var/run/mcelog-client"}) }
        it { is_expected.to contain_file('mcelog.load').with(content: %r{PersistentNotification false}) }
      end

      case facts['os']['family']
      when 'RedHat'
        context 'on osfamily => RedHat' do
          it { is_expected.to contain_package('collectd-mcelog').with(ensure: 'present') }
        end
      end

      context ':ensure => :mceloglogfile => true' do
        let :params do
          {
            mceloglogfile: '/var/log/mcelog'
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-mcelog.conf" do
          is_expected.to contain_file('mcelog.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-mcelog.conf"
          )
        end

        it { is_expected.to contain_file('mcelog.load').with(content: %r{McelogLogfile "/var/log/mcelog"}) }
      end

      context ':ensure => :memory => true' do
        let :params do
          {
            memory: {
              'mcelogclientsocket' => '/var/run/mcelog-client',
              'persistentnotification' => true
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-mcelog.conf" do
          is_expected.to contain_file('mcelog.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-mcelog.conf"
          )
        end

        it { is_expected.to contain_file('mcelog.load').with(content: %r{<Memory>}) }
        it { is_expected.to contain_file('mcelog.load').with(content: %r{McelogClientSocket "/var/run/mcelog-client"}) }
        it { is_expected.to contain_file('mcelog.load').with(content: %r{PersistentNotification true}) }
      end
    end
  end
end
