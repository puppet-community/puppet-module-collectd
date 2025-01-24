# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::load', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include collectd'
      end

      context 'report_relative in load.conf' do
        let :params do
          {
            report_relative: true
          }
        end

        it 'is present' do
          is_expected.to contain_file('load.load').
            without_content(%r{\s{2}ReportRelative true\s{2}})
        end
      end
    end
  end
end
