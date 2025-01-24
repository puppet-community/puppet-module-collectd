# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::disk', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and :disks => [\'sda\']' do
        let :params do
          { disks: ['sda'] }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-disk.conf" do
          is_expected.to contain_file('disk.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-disk.conf",
            content: %r{Disk  "sda"}
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { disks: ['sda'], ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-disk.conf" do
          is_expected.to contain_file('disk.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-disk.conf"
          )
        end
      end

      context ':manage_package => false' do
        let :params do
          {
            manage_package: false
          }
        end

        it 'Will not manage collectd-disk' do
          is_expected.not_to contain_package('collectd-disk').with(
            ensure: 'present',
            name: 'collectd-disk'
          )
        end
      end

      context ':manage_package => undef with collectd 5.5 and below' do
        let :facts do
          facts.merge(collectd_version: '5.4')
        end

        it 'Will not manage collectd-disk' do
          is_expected.not_to contain_package('collectd-disk').with(
            ensure: 'present',
            name: 'collectd-disk'
          )
        end
      end

      context ':disks is not an array' do
        let :params do
          { disks: 'sda' }
        end

        it 'Will raise an error about :disks being a String' do
          is_expected.to compile.and_raise_error(%r{String})
        end
      end

      context ':udevnameattr on collectd < 5.5' do
        let :params do
          { udevnameattr: 'DM_NAME' }
        end
        let :facts do
          facts.merge(collectd_version: '5.4')
        end

        it 'Will not include the setting' do
          is_expected.to contain_file('disk.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-disk.conf"
          ).without_content(
            %r{UdevNameAttr DM_NAME}
          )
        end
      end

      context ':udevnameattr on collectd >= 5.5' do
        let :params do
          { udevnameattr: 'DM_NAME' }
        end
        let :facts do
          facts.merge(collectd_version: '5.5')
        end

        it 'Will include the setting' do
          is_expected.to contain_file('disk.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-disk.conf",
            content: %r{UdevNameAttr DM_NAME}
          )
        end
      end

      case [facts['os']['family'], facts['os']['release']['major']]
      when %w[RedHat 8]
        context ':manage_package => undef with collectd 5.5 and up' do
          let :facts do
            facts.merge(collectd_version: '5.5')
          end

          it 'Will manage collectd-disk' do
            is_expected.to contain_package('collectd-disk').with(
              ensure: 'present',
              name: 'collectd-disk'
            )
          end
        end

        context ':manage_package => true' do
          let :params do
            {
              manage_package: true
            }
          end

          it 'Will manage collectd-disk' do
            is_expected.to contain_package('collectd-disk').with(
              ensure: 'present',
              name: 'collectd-disk'
            )
          end
        end

        context ':install_options install package with install options' do
          let :params do
            {
              package_install_options: ['--enablerepo=mycollectd-repo']
            }
          end

          it 'Will install the package with install options' do
            is_expected.to contain_package('collectd-disk').with(
              ensure: 'present',
              install_options: ['--enablerepo=mycollectd-repo']
            )
          end
        end
      end
    end
  end
end
