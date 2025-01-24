# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::genericjmx::connection', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      options = os_specific_options(facts)
      let :facts do
        facts
      end
      let(:title) { 'foo.example.com' }
      let(:concat_fragment_name) { 'collectd_plugin_genericjmx_conf_foo.example.com' }
      let(:config_filename) { "#{options[:plugin_conf_dir]}/15-genericjmx.conf" }
      let(:default_params) do
        {
          service_url: 'foo:bar:baz'
        }
      end

      context 'required params' do
        let(:params) do
          default_params.merge(collect: [])
        end

        it 'provides a Connection concat fragment' do
          is_expected.to contain_concat__fragment(concat_fragment_name).with(
            target: config_filename,
            order: '20'
          )
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{<Connection>.*</Connection>}m) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{ServiceURL "foo:bar:baz"}) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{User}) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{Password}) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstancePrefix}) }
      end

      context 'hostname override' do
        let(:params) do
          default_params.merge(host: 'bar.example.com',
                               collect: [])
        end

        it 'provides a Connection concat fragment' do
          is_expected.to contain_concat__fragment(concat_fragment_name).with(
            target: config_filename,
            order: '20'
          )
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Host "bar\.example\.com"}) }
      end

      context 'with a collect array of multiple values' do
        let(:params) do
          default_params.merge(collect: %w[foo bar baz])
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Collect "foo".*Collect "bar".*Collect "baz"}m) }
      end

      context 'with a collect array of one value' do
        let(:params) do
          default_params.merge(collect: %w[bat])
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Collect "bat"}) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{(.*Collect.*){2,}}m) }
      end

      context 'username and password' do
        let(:params) do
          default_params.merge(
            user: 'alice',
            password: 'aoeuhtns',
            collect: []
          )
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{User "alice"}) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Password "aoeuhtns"}) }
      end

      context 'instance_prefix' do
        let(:params) do
          default_params.merge(
            instance_prefix: 'bat',
            collect: []
          )
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstancePrefix "bat"}) }
      end
    end
  end
end
