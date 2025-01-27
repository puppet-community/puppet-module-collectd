# frozen_string_literal: true

require 'spec_helper'

describe 'Collectd::Modbus::Slave' do
  it { is_expected.to allow_values({ 'instance' => 'foo1', 'collect' => 'bar1' }) }
  it { is_expected.to allow_values({ 'instance' => 'foo1', 'collect' => %w[bar1 bar2] }) }

  it { is_expected.not_to allow_values(nil) }
  it { is_expected.not_to allow_values({ 'collect' => ['bar1'] }) }
  it { is_expected.not_to allow_values({ 'instance' => 'foo1' }) }
  it { is_expected.not_to allow_values({ 'instance' => 'foo1', 'collect' => [] }) }
end
