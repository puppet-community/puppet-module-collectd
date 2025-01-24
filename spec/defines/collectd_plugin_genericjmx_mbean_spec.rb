# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::genericjmx::mbean', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      options = os_specific_options(facts)
      let :facts do
        facts
      end
      let(:title) { 'foo' }
      let(:concat_fragment_name) { 'collectd_plugin_genericjmx_conf_foo' }
      let(:config_filename) { "#{options[:plugin_conf_dir]}/15-genericjmx.conf" }
      let(:default_params) do
        {
          object_name: 'bar',
          values: []
        }
      end

      # empty values array is technically not valid, but we'll test those cases later
      context 'defaults' do
        let(:params) { default_params }

        it 'provides an MBean stanza concat fragment' do
          is_expected.to contain_concat__fragment(concat_fragment_name).with(
            target: config_filename,
            order: '10'
          )
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{<MBean "foo">\s+ObjectName "bar".+</MBean>}m) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstancePrefix}) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstanceFrom}) }
      end

      context 'instance_prefix set' do
        let(:params) do
          default_params.merge(instance_prefix: 'baz')
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstancePrefix "baz"}) }
      end

      context 'with an instance_from array of multiple values' do
        let(:params) do
          default_params.merge(instance_from: %w[foo bar baz])
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstanceFrom "foo"\s+InstanceFrom "bar"\s+InstanceFrom "baz"}) }
      end

      context 'with an instance_from array of one value' do
        let(:params) do
          default_params.merge(instance_from: %w[bat])
        end

        it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstanceFrom "bat"}) }
        it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{(.*InstanceFrom.*){2,}}) }
      end

      context 'with default_values_args' do
        let(:default_values_args) do
          {
            'mbean_type' => 'foo',
            'attribute'  => 'bar'
          }
        end

        # testing the Value template section is going to be messy
        context 'value section defaults' do
          let(:params) do
            default_params.merge(values: [default_values_args])
          end

          it 'has a value stanza' do
            is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{<Value>.*</Value>}m)
          end

          it 'has only one value stanza' do
            is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{(.*<Value>.*){2,}})
          end

          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Type "foo"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Table false}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Attribute "bar"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstancePrefix}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstanceFrom}) }
        end

        context 'value section instance_prefix set' do
          let(:params) do
            default_params.merge(values: [default_values_args.merge('instance_prefix' => 'baz')])
          end

          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstancePrefix "baz"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstanceFrom}) }
        end

        context 'value section instance_from array, multiple values' do
          let(:params) do
            default_params.merge(values: [default_values_args.merge('instance_from' => %w[alice bob carol])])
          end

          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstanceFrom "alice"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstanceFrom "bob"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstanceFrom "carol"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstancePrefix}) }
        end

        context 'value section instance_from array, single value' do
          let(:params) do
            default_params.merge(values: [default_values_args.merge('instance_from' => %w[dave])])
          end

          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{InstanceFrom "dave"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{(.*InstancePrefix.*){2,}}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{InstancePrefix}) }
        end

        context 'value section attribute array' do
          let(:params) do
            default_params.merge(values: [default_values_args.merge('attribute' => %w[alice bob carol])])
          end

          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Attribute "alice"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Attribute "bob"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Attribute "carol"}) }
        end

        context 'value section attribute string' do
          let(:params) do
            default_params.merge(values: [default_values_args.merge('attribute' => 'dave')])
          end

          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Attribute "dave"}) }
          it { is_expected.to contain_concat__fragment(concat_fragment_name).without_content(%r{(.*Attribute.*){2,}}) }
        end

        context 'value section table true-like' do
          ['true', true].each do |truthy|
            let(:params) do
              default_params.merge(values: [default_values_args.merge('table' => truthy)])
            end

            it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Table true}) }
          end
        end

        context 'value section table false-like' do
          ['false', false].each do |truthy|
            let(:params) do
              default_params.merge(values: [default_values_args.merge('table' => truthy)])
            end

            it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{Table false}) }
          end
        end

        context 'multiple values' do
          let(:params) do
            default_params.merge(values: [default_values_args, default_values_args])
          end

          it { is_expected.to contain_concat__fragment(concat_fragment_name).with_content(%r{(.*<Value>.*</Value>.*){2}}m) }
        end
      end
    end
  end
end
