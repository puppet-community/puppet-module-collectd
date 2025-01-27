# frozen_string_literal: true

require 'spec_helper'

describe 'Collectd::Modbus::Host' do
  let(:slaves) do
    {
      1 => { 'instance' => 'foo1', 'collect' => 'bar1' },
      2 => { 'instance' => 'foo2', 'collect' => %w[bar1 bar2] },
    }
  end

  it { is_expected.to allow_values({ 'address' => '127.0.0.1', 'port' => 1234, 'slaves' => slaves }) }
  it { is_expected.to allow_values({ 'address' => '127.0.0.1', 'port' => 1234, 'slaves' => slaves, 'interval' => 120 }) }

  it { is_expected.not_to allow_values(nil) }
  it { is_expected.not_to allow_values({ 'address' => '127.0.0.1', 'port' => '1234', 'slaves' => slaves, 'interval' => 120 }) }
  it { is_expected.not_to allow_values({ 'port' => 1234, 'slaves' => slaves, 'interval' => 120 }) }
end
