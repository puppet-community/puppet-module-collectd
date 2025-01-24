# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::openldap', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-openldap.conf" do
          content = <<~EOS
            <Plugin "openldap">
              <Instance "localhost">
                URL "ldap://localhost/"
              </Instance>
            </Plugin>
          EOS
          is_expected.to contain_collectd__plugin('openldap').with_content(content)
        end
      end

      context ':instances param is a hash' do
        let :params do
          {
            instances: {
              'ldap1' => {
                'url' => 'ldap://ldap1.example.com'
              },
              'ldap2' => {
                'url' => 'ldap://ldap2.example.com',
                'binddn' => 'cn=Monitor',
                'password' => 'password'
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-openldap.conf with two :instances params" do
          content = <<~EOS
            <Plugin "openldap">
              <Instance "ldap1">
                URL "ldap://ldap1.example.com"
              </Instance>
              <Instance "ldap2">
                URL "ldap://ldap2.example.com"
                BindDN "cn=Monitor"
                Password "password"
              </Instance>
            </Plugin>
          EOS
          is_expected.to contain_collectd__plugin('openldap').with_content(content)
        end
      end

      context ':interval is not default and is an integer' do
        let :params do
          { interval: 15 }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-openldap.conf" do
          is_expected.to contain_file('openldap.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-openldap.conf",
            content: %r{^  Interval 15}
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-openldap.conf" do
          is_expected.to contain_file('openldap.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-openldap.conf"
          )
        end
      end
    end
  end
end
