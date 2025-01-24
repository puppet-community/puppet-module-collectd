# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::java', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context ':ensure => present, defaults' do
        it 'Will load the plugin' do
          is_expected.to contain_collectd__plugin('java').with(ensure: 'present')
        end
      end

      context ':ensure => absent' do
        let(:params) do
          {
            ensure: 'absent'
          }
        end

        it 'will not load the plugin' do
          is_expected.to contain_collectd__plugin('java').with(ensure: 'absent')
        end
      end

      context 'jvmarg parameter array' do
        let(:params) do
          {
            jvmarg: %w[foo bar baz]
          }
        end

        it 'will have multiple jvmarg parameters' do
          is_expected.to contain_collectd__plugin('java').with_content(%r{JVMArg "foo".+JVMArg "bar".+JVMArg "baz"}m)
        end
      end

      context 'jvmarg parameter string' do
        let(:params) do
          {
            jvmarg: 'bat'
          }
        end

        it 'will have a JVMArg parameter' do
          is_expected.to contain_collectd__plugin('java').with_content(%r{JVMArg "bat"})
        end

        it 'will only have one JVMArg parameter' do
          is_expected.to contain_collectd__plugin('java').without_content(%r{(.*JVMArg.*){2,}}m)
        end
      end

      context 'jvmarg parameter string & loadplugin java hash with no options' do
        let(:params) do
          {
            jvmarg: 'dog',
            loadplugin: { 'name.java' => [] }
          }
        end

        it 'will have a JVMArg parameter' do
          is_expected.to contain_collectd__plugin('java').with_content(%r{JVMArg "dog"})
        end

        it 'will have a java plugin' do
          is_expected.to contain_collectd__plugin('java').with_content(%r{LoadPlugin "name.java"})
        end
      end

      context 'jvmarg parameter string & loadplugin java hash with options' do
        let(:params) do
          {
            jvmarg: 'dog',
            loadplugin: { 'name.java' => ['key = value'] }
          }
        end

        it 'will have a java plugin option' do
          is_expected.to contain_collectd__plugin('java').with_content(%r{key = value})
        end
      end

      context 'jvmarg parameter empty' do
        let(:params) do
          {
            jvmarg: []
          }
        end

        it 'will not have a <Plugin java> stanza' do
          is_expected.to contain_collectd__plugin('java').without_content(%r{<Plugin java>})
        end

        it 'will not have any jvmarg parameters' do
          is_expected.to contain_collectd__plugin('java').without_content(%r{JVMArg})
        end
      end

      context 'jvmarg parameter empty & java plugin option provided' do
        let(:params) do
          {
            jvmarg: [],
            loadplugin: { 'name.java' => ['key = value'] }
          }
        end

        it 'will not have a java plugin load stanza' do
          is_expected.to contain_collectd__plugin('java').without_content(%r{name.java})
        end

        it 'will not have java plugin options stanza' do
          is_expected.to contain_collectd__plugin('java').without_content(%r{key = value})
        end
      end

      case facts['os']['family']
      when 'RedHat'
        context 'java_home option is empty' do
          it 'will not contain libjvm' do
            is_expected.not_to contain_exec('Link libjvm.so on OpenJDK').with_onlyif('/usr/bin/test -e /bla/jre/lib/server/libjvm.so')
            is_expected.not_to contain_exec('Link libjvm.so on Oracle').with_onlyif('/usr/bin/test -e /bla/jre/lib/amd64/server/libjvm.so')
            is_expected.not_to contain_exec('/sbin/ldconfig')
          end
        end

        context 'java_home option provided' do
          let(:params) do
            {
              java_home: '/bla'
            }
          end

          it 'will contain libjvm' do
            is_expected.to contain_exec('Link libjvm.so on OpenJDK').with_onlyif('/usr/bin/test -e /bla/jre/lib/server/libjvm.so')
            is_expected.to contain_exec('Link libjvm.so on Oracle').with_onlyif('/usr/bin/test -e /bla/jre/lib/amd64/server/libjvm.so')
            is_expected.to contain_exec('/sbin/ldconfig')
          end
        end
      end
    end
  end
end
