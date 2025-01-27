# frozen_string_literal: true

require 'spec_helper'

describe 'Collectd::Modbus::Data' do
  it do
    is_expected.to allow_values({
                                  'type' => 'foo',
                                  'register_base' => 123,
                                  'register_type' => 'Int32',
                                })
  end

  it do
    is_expected.to allow_values({
                                  'type' => 'foo',
                                  'register_base' => 123,
                                  'register_type' => 'Int32',
                                  'register_cmd' => 'ReadInput',
                                })
  end

  it do
    is_expected.to allow_values({
                                  'instance' => 'foobar',
                                  'type' => 'foo',
                                  'register_base' => 123,
                                  'register_type' => 'Int32',
                                })
  end

  it { is_expected.not_to allow_values(nil) }
  it { is_expected.not_to allow_values({ 'type' => 'foo', 'register_base' => 123 }) }
end
