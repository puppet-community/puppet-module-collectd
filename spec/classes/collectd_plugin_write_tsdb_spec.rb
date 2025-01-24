# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::write_tsdb', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'ensure: present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-write_tsdb.conf" do
          is_expected.to contain_file('write_tsdb.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-write_tsdb.conf",
            content: %r{LoadPlugin write_tsdb}
          )
        end
      end

      context 'ensure: absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-write_tsdb.conf" do
          is_expected.to contain_file('write_tsdb.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-write_tsdb.conf"
          )
        end
      end
    end
  end
end
