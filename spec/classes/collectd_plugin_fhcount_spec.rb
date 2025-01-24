# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::fhcount', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        context 'fhcount options should be set with collectd 5.5' do
          let :facts do
            facts.merge(collectd_version: '5.5')
          end
          let :params do
            {
              valuesabsolute: false,
              valuespercentage: true
            }
          end

          it "Will include ValuesAbsolute in #{options[:plugin_conf_dir]}/10-fhcount.conf" do
            is_expected.to contain_file('fhcount.load').with_content(%r{ValuesAbsolute false})
          end

          it "Will include ValuesPercentage in #{options[:plugin_conf_dir]}/10-fhcount.conf" do
            is_expected.to contain_file('fhcount.load').with_content(%r{ValuesPercentage true})
          end
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will remove #{options[:plugin_conf_dir]}/10-fhcount.conf" do
          is_expected.to contain_file('fhcount.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-fhcount.conf",
            content: %r{LoadPlugin fhcount}
          )
        end
      end
    end
  end
end
