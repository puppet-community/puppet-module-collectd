# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::network::server', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, create one complex server' do
        let(:title) { 'node1' }
        let :params do
          {
            port: 1234,
            interface: 'eth0',
            securitylevel: 'Encrypt',
            username: 'foo',
            password: 'bar'
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/network-server-node1.conf for collectd >= 4.7" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/network-server-node1.conf").with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/network-server-node1.conf",
            content: "<Plugin network>\n  <Server \"node1\" \"1234\">\n    SecurityLevel \"Encrypt\"\n    Username \"foo\"\n    Password \"bar\"\n    Interface \"eth0\"\n\n  </Server>\n</Plugin>\n"
          )
        end
      end

      context ':ensure => absent' do
        let(:title) { 'node1' }
        let :params do
          {
            ensure: 'absent'
          }
        end

        it "Will not create #{options[:plugin_conf_dir]}/network-server-node1.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/network-server-node1.conf").with(ensure: 'absent')
        end
      end
    end
  end
end
