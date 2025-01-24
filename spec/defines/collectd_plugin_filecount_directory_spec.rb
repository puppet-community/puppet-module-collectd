# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::filecount::directory', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'simple case' do
        let(:title) { 'test' }
        let :params do
          {
            path: '/var/tmp/test'
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/15-filecount-test.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/15-filecount-test.conf").with_content(
            "<Plugin \"filecount\">\n  <Directory \"/var/tmp/test\">\n    Instance \"test\"\n  </Directory>\n</Plugin>\n"
          )
        end
      end

      context 'advanced case' do
        let(:title) { 'test' }
        let :params do
          {
            path: '/path/to/dir',
            pattern: '*.conf',
            mtime: '-5m',
            recursive: true,
            includehidden: false
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/15-filecount-test.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/15-filecount-test.conf").with_content(
            "<Plugin \"filecount\">\n  <Directory \"/path/to/dir\">\n    Instance \"test\"\n    Name \"*.conf\"\n    MTime \"-5m\"\n    Recursive true\n    IncludeHidden false\n  </Directory>\n</Plugin>\n"
          )
        end
      end

      context 'recursive and includehidden false' do
        let(:title) { 'test' }
        let :params do
          {
            path: '/var/tmp/test',
            recursive: false,
            includehidden: false
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/15-filecount-test.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/15-filecount-test.conf").with_content(
            "<Plugin \"filecount\">\n  <Directory \"/var/tmp/test\">\n    Instance \"test\"\n    Recursive false\n    IncludeHidden false\n  </Directory>\n</Plugin>\n"
          )
        end
      end

      context 'ensure => absent' do
        let(:title) { 'test' }
        let :params do
          {
            ensure: 'absent',
            path: '/var/tmp/test'
          }
        end

        it "Will create #{options[:plugin_conf_dir]}/15-filecount-test.conf" do
          is_expected.to contain_file("#{options[:plugin_conf_dir]}/15-filecount-test.conf").with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/15-filecount-test.conf"
          )
        end
      end
    end
  end
end
