# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::cpu', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        context ':ensure => present and collectd version < 5.5' do
          let :facts do
            facts.merge(collectd_version: '5.4')
          end

          it "Will create #{options[:plugin_conf_dir]}/10-cpu.conf to load the plugin" do
            is_expected.to contain_file('cpu.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-cpu.conf",
              content: %r{LoadPlugin cpu}
            )
          end

          it "Will not include ReportByState in #{options[:plugin_conf_dir]}/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{ReportByState})
          end

          it "Will not include ReportByCpu in #{options[:plugin_conf_dir]}/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{ReportByCpu})
          end

          it "Will not include ValuesPercentage in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{ValuesPercentage})
          end

          it "Will not include ReportGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{ReportGuestState})
          end

          it "Will not include SubtractGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{SubtractGuestState})
          end
        end

        context 'cpu options should be set with collectd 5.5' do
          let :facts do
            facts.merge(collectd_version: '5.5')
          end
          let :params do
            {
              reportbystate: false,
              reportbycpu: false,
              valuespercentage: true
            }
          end

          it "Will include ReportByState in #{options[:plugin_conf_dir]}/10-cpu.conf" do
            is_expected.to contain_file('cpu.load').with_content(%r{ReportByState false})
          end

          it "Will include ReportByCpu in #{options[:plugin_conf_dir]}/10-cpu.conf" do
            is_expected.to contain_file('cpu.load').with_content(%r{ReportByCpu false})
          end

          it "Will include ValuesPercentage in #{options[:plugin_conf_dir]}/10-cpu.conf" do
            is_expected.to contain_file('cpu.load').with_content(%r{ValuesPercentage true})
          end

          it "Will not include ReportGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{ReportGuestState})
          end

          it "Will not include SubtractGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{SubtractGuestState})
          end
        end

        context 'cpu options should be set with collectd 5.6' do
          let :facts do
            facts.merge(collectd_version: '5.6')
          end
          let :params do
            {
              reportnumcpu: true
            }
          end

          it "Will include ValuesPercentage in #{options[:plugin_conf_dir]}/10-cpu.conf" do
            is_expected.to contain_file('cpu.load').with_content(%r{ReportNumCpu true})
          end

          it "Will not include ReportGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{ReportGuestState})
          end

          it "Will not include SubtractGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.not_to contain_file('cpu.load').with_content(%r{SubtractGuestState})
          end
        end

        context 'cpu options should be set with collectd 5.8' do
          let :facts do
            facts.merge(collectd_version: '5.8')
          end
          let :params do
            {
              reportgueststate: true,
              subtractgueststate: false
            }
          end

          it "Will include ReportGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.to contain_file('cpu.load').with_content(%r{ReportGuestState true})
          end

          it "Will include SubtractGuestState in #{options[:plugin_conf_dir]}d/10-cpu.conf" do
            is_expected.to contain_file('cpu.load').with_content(%r{SubtractGuestState false})
          end
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will remove #{options[:plugin_conf_dir]}/10-cpu.conf" do
          is_expected.to contain_file('cpu.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-cpu.conf",
            content: %r{LoadPlugin cpu}
          )
        end
      end
    end
  end
end
