# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::mongodb', type: :class do
  let :pre_condition do
    'include collectd'
  end

  let :default_params do
    {
      db_user: 'test_user',
      db_pass: 'password'
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default values for all parameters' do
        let :params do
          default_params
        end

        it { is_expected.to contain_class('collectd::plugin::mongodb') }

        it do
          is_expected.to contain_file('mongodb.load').with(
            'ensure' => 'present'
          )
        end

        default_fixture = File.read(fixtures('plugins/mongodb.conf.default'))
        it { is_expected.to contain_file('mongodb.load').with_content(default_fixture) }
      end

      describe 'with ensure parameter' do
        %w[present absent].each do |value|
          context "set to a valid value of #{value}" do
            let :params do
              default_params.merge(ensure: value.to_s)
            end

            it do
              is_expected.to contain_file('mongodb.load').with(
                'ensure' => value
              )
            end
          end
        end
      end

      describe 'with interval parameter' do
        ['10.0', '3600'].each do |value|
          context "set to a valid numeric of #{value}" do
            let(:params) do
              default_params.merge(interval: value.to_s)
            end

            it { is_expected.to contain_file('mongodb.load').with_content(%r{\s*Interval\s+#{Regexp.escape(value)}}) }
          end
        end
      end

      describe 'with db_host parameter' do
        context 'set to a valid IP' do
          let :params do
            default_params.merge(db_host: '127.0.0.1')
          end

          hostdb_fixture = File.read(fixtures('plugins/mongodb.conf.hostdb'))
          it { is_expected.to contain_file('mongodb.load').with_content(hostdb_fixture) }
        end
      end

      describe 'with db_user parameter' do
        context 'set to a valid user name' do
          let :params do
            default_params.merge(db_user: 'test_user')
          end

          confdb_fixture = File.read(fixtures('plugins/mongodb.conf.db_user'))
          it { is_expected.to contain_file('mongodb.load').with_content(confdb_fixture) }
        end
      end

      describe 'with db_pass parameter' do
        context 'set to a valid password' do
          let :params do
            default_params.merge(db_pass: 'foo')
          end

          dbpass_fixture = File.read(fixtures('plugins/mongodb.conf.db_pass'))
          it { is_expected.to contain_file('mongodb.load').with_content(dbpass_fixture) }
        end
      end

      describe 'with configured_dbs parameter' do
        context 'set to a valid value with db_port defined and a single db' do
          let :params do
            default_params.merge(configured_dbs: [25],
                                 db_port: 8080)
          end

          dbport_single_fixture = File.read(fixtures('plugins/mongodb.conf.configured_dbs_single'))
          it { is_expected.to contain_file('mongodb.load').with_content(dbport_single_fixture) }
        end

        context 'set to a valid value with db_port defined and multiple DBs' do
          let :params do
            default_params.merge(configured_dbs: [25, 26],
                                 db_port: 8080)
          end

          dbport_multi_fixture = File.read(fixtures('plugins/mongodb.conf.configured_dbs_multiple'))
          it { is_expected.to contain_file('mongodb.load').with_content(dbport_multi_fixture) }
        end
      end

      describe 'with collectd_dir parameter' do
        context 'defined' do
          let :params do
            default_params.merge(collectd_dir: '/tmp/collectd_test_dir')
          end

          collectddir_fixture = File.read(fixtures('plugins/mongodb.conf.collectddir'))
          it { is_expected.to contain_file('mongodb.load').with_content(collectddir_fixture) }
        end
      end
    end
  end
end
