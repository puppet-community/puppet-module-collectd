# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::filter::rule', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let(:title) { 'MyRule' }
      let(:params) { { chain: 'MyChain' } }

      options = os_specific_options(facts)

      context 'Add rule' do
        it 'create header and footer of rule' do
          is_expected.to contain_concat__fragment("#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf_10_MyRule_0").with(
            order: '10_MyRule_0',
            content: '  <Rule "MyRule">',
            target: "#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf"
          )
          is_expected.to contain_concat__fragment("#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf_10_MyRule_99").with(
            order: '10_MyRule_99',
            content: '  </Rule>',
            target: "#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf"
          )
        end
      end
    end
  end
end
