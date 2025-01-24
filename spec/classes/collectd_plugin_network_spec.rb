# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::network', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-network.conf" do
          is_expected.to contain_file('network.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-network.conf"
          )
        end
      end
    end
  end
end
