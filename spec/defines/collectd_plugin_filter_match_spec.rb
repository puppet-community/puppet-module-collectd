# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::filter::match', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      options = os_specific_options(facts)
      let :facts do
        facts
      end
      let(:title) { 'MyMatch' }
      let(:default_params) { { chain: 'MyChain', rule: 'MyRule' } }
      let(:concat_fragment_target) { "#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf" }
      let(:concat_fragment_order) { '10_MyRule_1_MyMatch' }
      let(:concat_fragment_name) { "#{options[:plugin_conf_dir]}/filter-chain-MyChain.conf_10_MyRule_1_MyMatch" }

      context 'Add match regex to rule with options' do
        let(:params) do
          default_params.merge(
            plugin: 'regex',
            options: {
              'Host'   => 'customer[0-9]+',
              'Plugin' => '^foobar$'
            }
          )
        end

        it 'Will ensure that plugin is loaded' do
          is_expected.to contain_collectd__plugin('match_regex').with(order: '02')
        end

        it 'Will add match to rule' do
          is_expected.to contain_concat__fragment(concat_fragment_name).with(
            order: concat_fragment_order,
            target: concat_fragment_target
          )
          is_expected.to contain_concat__fragment(concat_fragment_name).with(content: %r{<Match "regex">})
          is_expected.to contain_concat__fragment(concat_fragment_name).with(content: %r{Host "customer\[0-9\]\+"})
          is_expected.to contain_concat__fragment(concat_fragment_name).with(content: %r{Plugin "\^foobar\$"})
        end
      end

      context 'Add match empty_counter to rule without options' do
        let(:params) do
          default_params.merge(plugin: 'empty_counter')
        end

        it 'Will ensure that plugin is loaded' do
          is_expected.to contain_collectd__plugin('match_empty_counter').with(order: '02')
        end

        it 'Will add match to rule' do
          is_expected.to contain_concat__fragment(concat_fragment_name).with(
            order: concat_fragment_order,
            target: concat_fragment_target
          )
          is_expected.to contain_concat__fragment(concat_fragment_name).with(content: %r{Match "empty_counter"})
        end
      end
    end
  end
end
