# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::curl::page', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context 'simple case' do
        let(:title) { 'test' }
        let :params do
          {
            url: 'http://www.example.com/query',
            matches: [{ 'regex' => 'SPAM \\(Score: (-?[0-9]+\\.[0-9]+)\\)', 'dstype' => 'CounterAdd', 'type' => 'counter' }],
            measureresponsecode: true
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/curl-test.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/curl-test.conf").with_content(
            "<Plugin curl>\n  <Page \"test\">\n    URL \"http://www.example.com/query\"\n    MeasureResponseCode true\n  <Match>\n    Regex \"SPAM \\(Score: (-?[0-9]+\\.[0-9]+)\\)\"\n    DSType \"CounterAdd\"\n    Type \"counter\"\n  </Match>\n\n  </Page>\n</Plugin>\n"
          )
        end
      end
    end
  end
end
