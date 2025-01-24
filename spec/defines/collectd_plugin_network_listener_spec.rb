# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::network::listener', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, collectd version 5.1.0' do
        let(:title) { 'mylistener' }
        let :params do
          {
            port: 1234
          }
        end

        it 'Will create /etc/collectd.d/network-listener-mylistener.conf for collectd >= 4.7' do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/network-listener-mylistener.conf").with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/network-listener-mylistener.conf",
            content: "<Plugin network>\n  <Listen \"mylistener\" \"1234\">\n\n  </Listen>\n</Plugin>\n"
          )
        end
      end
    end
  end
end
