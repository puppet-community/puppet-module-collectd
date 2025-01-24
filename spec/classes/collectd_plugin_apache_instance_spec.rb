# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::apache::instance', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'simple usage' do
        let :title do
          'site2'
        end

        let :params do
          {
            'url' => 'https://another.example.com',
            'user' => 'nobody',
            'password' => 'secrets',
            'verifypeer' => false,
            'verifyhost' => true,
            'cacert' => '/etc/foobar/ca.crt',
            'sslciphers' => 'TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256',
            'timeout' => 120
          }
        end

        it 'creates an apache instance' do
          content_instance_file = <<~EOS
            <Plugin "apache">
              <Instance "site2">
                URL "https://another.example.com"
                User "nobody"
                Password "secrets"
                VerifyPeer false
                VerifyHost true
                CACert "/etc/foobar/ca.crt"
                SSLCiphers "TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256"
                Timeout 120
              </Instance>
            </Plugin>
          EOS
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('collectd')
          is_expected.to contain_class('collectd::plugin::apache')
          is_expected.to contain_file('apache-instance-site2.conf').with(
            content: content_instance_file,
            path: "#{options[:plugin_conf_dir]}/25-apache-instance-site2.conf"
          )
        end
      end
    end
  end
end
