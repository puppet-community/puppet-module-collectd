# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::nut', type: :class do
  let :pre_condition do
    'include collectd'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      options = os_specific_options(os_facts)
      let :facts do
        os_facts
      end
      let(:config_filename) { "#{options[:plugin_conf_dir]}/10-nut.conf" }
      let(:config_filename2) { "#{options[:plugin_conf_dir]}/nut-ups-ups1@localhost.conf" }

      context ':ensure => present, default params' do
        it 'Will create 10-nut.conf' do
          is_expected.to contain_file('nut.load').
            with(ensure: 'present',
                 path: config_filename,
                 content: %r{LoadPlugin nut})
        end
      end

      context ':ensure => present, single entry' do
        let :params do
          { upss: ['ups1@localhost'] }
        end

        it 'Will create localhost.conf' do
          is_expected.to contain_file(config_filename2).
            with(ensure: 'present',
                 path: config_filename2,
                 content: %r{UPS "ups1@localhost"})
        end
      end
    end
  end
end
