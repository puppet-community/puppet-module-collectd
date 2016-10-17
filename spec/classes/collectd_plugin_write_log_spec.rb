require 'spec_helper'

describe 'collectd::plugin::write_log', type: :class do
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7'
    }
  end

  context ':ensure => present and :format => \'JSON\'' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      { format: 'JSON' }
    end
    it 'Will create /etc/collectd.d/10-write_log.conf' do
      should contain_file('write_log.load').with(ensure: 'present',
                                                 path: '/etc/collectd.d/10-write_log.conf',
                                                 content: "#\ Generated by Puppet\n<LoadPlugin write_log>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"write_log\">\n  Format \"JSON\"\n</Plugin>\n\n")
    end
  end

  context ':ensure => present and :format => \'Graphite\'' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      { format: 'Graphite' }
    end
    it 'Will create /etc/collectd.d/10-write_log.conf' do
      should contain_file('write_log.load').with(ensure: 'present',
                                                 path: '/etc/collectd.d/10-write_log.conf',
                                                 content: "#\ Generated by Puppet\n<LoadPlugin write_log>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"write_log\">\n  Format \"Graphite\"\n</Plugin>\n\n")
    end
  end

  context ':ensure => absent' do
    let :params do
      { ensure: 'absent' }
    end
    it 'Will not create /etc/collectd.d/10-write_log.conf' do
      should contain_file('write_log.load').with(ensure: 'absent',
                                                 path: '/etc/collectd.d/10-write_log.conf')
    end
  end
end
