# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::tail::file', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context 'Example from README' do
        let(:title) { 'exim-log' }
        let :params do
          {
            filename: '/var/log/exim4/mainlog',
            instance: 'exim',
            matches: [
              {
                'regex'    => 'S=([1-9][0-9]*)',
                'dstype'   => 'CounterAdd',
                'type'     => 'ipt_bytes',
                'instance' => 'total'
              },
              {
                'regex'    => '\\<R=local_user\\>',
                'dstype'   => 'CounterInc',
                'type'     => 'counter',
                'instance' => 'local_user'
              }
            ]
          }
        end

        describe "#{options[:plugin_conf_dir]}/tail-exim-log.conf" do
          it "Will create #{options[:plugin_conf_dir]}/tail-exim-log.conf" do
            is_expected.to contain_file('exim-log.conf').with(
              'ensure' => 'present',
              'path'   => "#{options[:plugin_conf_dir]}/tail-exim-log.conf"
            ).that_notifies('Service[collectd]')
          end

          it "renders #{options[:plugin_conf_dir]}/tail-exim-log.conf correctly" do
            content = catalogue.resource('file', 'exim-log.conf').send(:parameters)[:content]
            expected_content  = %(# Generated by Puppet\n)
            expected_content += %(\n)
            expected_content += %(<Plugin "tail">\n)
            expected_content += %( <File "/var/log/exim4/mainlog">\n)
            expected_content += %(  Instance "exim"\n)
            expected_content += %(  <Match>\n)
            expected_content += %(   Regex "S=([1-9][0-9]*)"\n)
            expected_content += %(   DSType "CounterAdd"\n)
            expected_content += %(   Type "ipt_bytes"\n)
            expected_content += %(   Instance "total"\n)
            expected_content += %(  </Match>\n)
            expected_content += %(  <Match>\n)
            expected_content += %(   Regex "\\<R=local_user\\>"\n)
            expected_content += %(   DSType "CounterInc"\n)
            expected_content += %(   Type "counter"\n)
            expected_content += %(   Instance "local_user"\n)
            expected_content += %(  </Match>\n)
            expected_content += %( </File>\n)
            expected_content += %(</Plugin>)
            expect(content).to include(expected_content)
          end
        end
      end

      context "with match containing 'excluderegex'" do
        let(:title) { 'test' }
        let :params do
          {
            filename: '/var/log/exim4/mainlog',
            instance: 'exim',
            matches: [
              {
                'regex'        => 'S=([1-9][0-9]*)',
                'excluderegex' => 'U=root.*S=',
                'dstype'       => 'CounterAdd',
                'type'         => 'ipt_bytes',
                'instance'     => 'total'
              }
            ]
          }
        end

        it "templated file contains the 'ExcludeRegex' line" do
          content = catalogue.resource('file', 'test.conf').send(:parameters)[:content]
          expected_content  = %(  <Match>\n)
          expected_content += %(   Regex "S=([1-9][0-9]*)"\n)
          expected_content += %(   ExcludeRegex "U=root.*S="\n)
          expected_content += %(   DSType "CounterAdd"\n)
          expected_content += %(   Type "ipt_bytes"\n)
          expected_content += %(   Instance "total"\n)
          expected_content += %(  </Match>\n)
          expect(content).to include(expected_content)
        end
      end
    end
  end
end
