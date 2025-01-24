# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::curl', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)

      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-curl.conf" do
          is_expected.to contain_file('curl.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-curl.conf",
            content: %r{LoadPlugin curl}
          )
        end
      end

      context ':ensure => present, creating two pages' do
        let :params do
          {
            ensure: 'present',
            pages: {
              'stocks_ILD' => {
                'url'      => 'http://finance.google.com/finance?q=EPA%3AILD',
                'user'     => 'foo',
                'password' => 'bar',
                'matches'  => [
                  {
                    'dstype'   => 'GaugeAverage',
                    'instance' => 'ILD',
                    'regex'    => ']*> *([0-9]*\\.[0-9]+) *',
                    'type'     => 'stock_value'
                  }
                ]
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/curl-stocks_ILD.conf and #{options[:plugin_conf_dir]}/curl-stocks_GM.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/curl-stocks_ILD.conf").with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/curl-stocks_ILD.conf",
            content: "<Plugin curl>\n  <Page \"stocks_ILD\">\n    URL \"http://finance.google.com/finance?q=EPA%3AILD\"\n    User \"foo\"\n    Password \"bar\"\n  <Match>\n    Regex \"]*> *([0-9]*\\.[0-9]+) *\"\n    DSType \"GaugeAverage\"\n    Type \"stock_value\"\n    Instance \"ILD\"\n  </Match>\n\n  </Page>\n</Plugin>\n"
          )
        end
      end

      context ':ensure => present, verifypeer => false, verifyhost => false, measureresponsetime => true, matches empty' do
        let :params do
          {
            ensure: 'present',
            pages: {
              'selfsigned_ssl' => {
                'url'                 => 'https://some.selfsigned.ssl.site/',
                'verifypeer'          => false,
                'verifyhost'          => false,
                'measureresponsetime' => true
              }
            }
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/curl-selfsigned_ssl.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/curl-selfsigned_ssl.conf").with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/curl-selfsigned_ssl.conf",
            content: "<Plugin curl>\n  <Page \"selfsigned_ssl\">\n    URL \"https://some.selfsigned.ssl.site/\"\n    VerifyPeer false\n    VerifyHost false\n    MeasureResponseTime true\n  </Page>\n</Plugin>\n"
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-curl.conf" do
          is_expected.to contain_file('curl.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-curl.conf"
          )
        end
      end
    end
  end
end
