# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::filter', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and default parameters' do
        it "Will create #{options[:plugin_conf_dir]}/01-filter.conf to set the default Chains" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/01-filter.conf").with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/01-filter.conf",
            content: %r{PreCacheChain "PreChain"\nPostCacheChain "PostChain"}
          )
        end
      end

      context ':ensure => present and custom parameters' do
        let(:params) do
          {
            ensure: 'present',
            precachechain: 'MyPreChain',
            postcachechain: 'MyPostChain'
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/01-filter.conf to set the default Chains" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/01-filter.conf").with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/01-filter.conf",
            content: %r{PreCacheChain "MyPreChain"\nPostCacheChain "MyPostChain"}
          )
        end
      end

      context ':ensure => absent' do
        let(:params) do
          { ensure: 'absent' }
        end

        it "Will remove #{options[:plugin_conf_dir]}/01-filter.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/01-filter.conf").with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/01-filter.conf"
          )
        end

        it 'Will remove loads of match plugins for filter' do
          is_expected.to contain_file('match_regex.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-match_regex.conf")
          is_expected.to contain_file('match_timediff.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-match_timediff.conf")
          is_expected.to contain_file('match_value.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-match_value.conf")
          is_expected.to contain_file('match_empty_counter.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-match_empty_counter.conf")
          is_expected.to contain_file('match_hashed.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-match_hashed.conf")
        end

        it 'Will remove loads of target plugins for filter' do
          is_expected.to contain_file('target_notification.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-target_notification.conf")
          is_expected.to contain_file('target_replace.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-target_replace.conf")
          is_expected.to contain_file('target_set.load').with(ensure: 'absent', path: "#{options[:plugin_conf_dir]}/02-target_set.conf")
        end
      end
    end
  end
end
