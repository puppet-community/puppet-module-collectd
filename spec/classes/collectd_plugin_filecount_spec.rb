# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::filecount', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)

      context ':ensure => present and :directories => { \'active\' => \'/var/spool/postfix/active\' }' do
        let :params do
          { directories: { 'active' => '/var/spool/postfix/active' } }
        end

        it "Will create #{options[:plugin_conf_dir]}/10-filecount.conf" do
          is_expected.to contain_file('filecount.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-filecount.conf",
            content: %r{Directory "/var/spool/postfix/active"}
          )
        end
      end

      context 'new :directories format' do
        let :params do
          { directories: { 'foodir' => {
            'path'          => '/path/to/dir',
            'pattern'       => '*.conf',
            'mtime'         => '-5m',
            'recursive'     => true,
            'includehidden' => false
          } } }
        end

        it 'Will create foodir collectd::plugin::filecount::directory resource' do
          is_expected.to contain_collectd__plugin__filecount__directory('foodir').with(
            ensure: 'present',
            path: '/path/to/dir',
            pattern: '*.conf',
            mtime: '-5m',
            recursive: true,
            includehidden: false
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { directories: { 'active' => '/var/spool/postfix/active' }, ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-filecount.conf" do
          is_expected.to contain_file('filecount.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-filecount.conf"
          )
        end
      end

      context ':directories is not hash' do
        let :params do
          { directories: '/var/spool/postfix/active' }
        end

        it 'Will raise an error about :directories being a String' do
          is_expected.to compile.and_raise_error(%r{String})
        end
      end

      context ':directories is empty' do
        it 'Will not create an empty <Plugin "filecount"> block' do
          is_expected.to contain_file('filecount.load').
            without_content(%r{<Plugin "filecount">})
        end
      end
    end
  end
end
