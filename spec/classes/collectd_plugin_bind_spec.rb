# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::bind', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include collectd'
      end

      options = os_specific_options(facts)
      context ':ensure => present' do
        let :params do
          {
            ensure: 'present',
            url: 'http://localhost:8053/',
            views: views
          }
        end

        let :views do
          :undef
        end

        it { is_expected.to contain_collectd__plugin('bind') }
        it { is_expected.to contain_file('old_bind.load').with_ensure('absent') }
        it { is_expected.to contain_file('older_bind.load').with_ensure('absent') }

        it 'Will create 10-bind.conf' do
          is_expected.to contain_file('bind.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-bind.conf"
          )
        end

        it { is_expected.to contain_file('bind.load').with(content: %r{<Plugin bind>}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{URL "http://localhost:8053/"}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{ParseTime false}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{OpCodes true}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{QTypes true}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{ServerStats true}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{ZoneMaintStats true}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{ResolverStats false}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{MemoryStats true}) }
        it { is_expected.to contain_file('bind.load').with(content: %r{</Plugin>}) }

        context 'when given a view' do
          let :views do
            [
              {
                name: 'internal',
                qtypes: true,
                resolverstats: true,
                cacherrsets: true
              },
              {
                name: 'external',
                qtypes: true,
                resolverstats: true,
                cacherrsets: true,
                zones: ['example.com/IN']
              }
            ]
          end

          it { is_expected.to contain_file('bind.load').with(content: %r{  <View "internal">\n    QTypes true\n    ResolverStats true\n    CacheRRSets true\n  </View>\n  <View "external">\n    QTypes true\n    ResolverStats true\n    CacheRRSets true\n    Zone "example\.com/IN"\n  </View>}) }
        end
      end
    end
  end
end
