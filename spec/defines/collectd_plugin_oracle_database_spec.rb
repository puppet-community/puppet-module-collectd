# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::oracle::database', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      options = os_specific_options(facts)
      let :facts do
        facts
      end
      let(:title) { 'foo' }
      let(:concat_fragment_name) { 'collectd_plugin_oracle_database_foo' }
      let(:config_filename) { "#{options[:plugin_conf_dir]}/15-oracle.conf" }
      let(:default_params) do
        {
          connect_id: 'connect_id',
          username: 'username',
          password: 'password',
          query: []
        }
      end

      # empty values array is technically not valid, but we'll test those cases later
      context 'defaults' do
        let(:params) { default_params }

        it 'provides an oracle database stanza concat fragment' do
          is_expected.to contain_concat__fragment(concat_fragment_name).with(target: config_filename,
                                                                             order: '20')
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{<Database "foo">\s+ConnectID "connect_id"\s+Username "username"\s+Password "password"}m) }
      end

      context 'query array' do
        let(:params) do
          default_params.merge(query: %w[foo bar baz])
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Query "foo"\s+Query "bar"\s+Query "baz"}) }
      end
    end
  end
end
