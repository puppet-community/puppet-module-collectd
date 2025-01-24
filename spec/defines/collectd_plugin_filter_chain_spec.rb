# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::filter::chain', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and default parameters' do
        let(:title) { 'MyChain' }

        it "Will create #{options[:plugin_conf_dir]}/filter-chain-MyChain.conf" do
          is_expected.to contain_concat("#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf").with(ensure: 'present')
          is_expected.to contain_concat__fragment("#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf_MyChain_head").with(
            order: '00',
            content: '<Chain "MyChain">',
            target: "#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf"
          )
          is_expected.to contain_concat__fragment("#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf_MyChain_footer").with(
            order: '99',
            content: '</Chain>',
            target: "#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf"
          )
        end

        it { is_expected.not_to contain_collectd__plugin__filter__target('z_chain-MyChain-target') }
      end

      context ':ensure => present and set a default target' do
        let(:title) { 'MyChain' }
        let(:params) do
          {
            target: 'set',
            target_options: {
              'PluginInstance' => 'coretemp',
              'TypeInstance'   => 'core3'
            }
          }
        end

        it 'Will add a default target with plugin set and options' do
          is_expected.to contain_collectd__plugin__filter__target('z_chain-MyChain-target').with(
            chain: 'MyChain',
            plugin: 'set',
            options: {
              'PluginInstance' => 'coretemp',
              'TypeInstance'   => 'core3'
            }
          )
        end
      end

      context ':ensure => absent' do
        let(:title) { 'MyChain' }
        let(:params) do
          {
            ensure: 'absent'
          }
        end

        it "Will remove file #{options[:plugin_conf_dir]}/filter-chain-MyChain.conf" do
          is_expected.to contain_concat("#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf").with(ensure: 'absent')
        end
      end
    end
  end
end
