# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::python', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)

      context ':ensure => present' do
        context ':ensure => present and default parameters' do
          it 'ensures that $modulepaths exits' do
            is_expected.to contain_file('/usr/local/lib/python2.7/dist-packages').with(ensure: 'directory')
          end

          it "Will create #{options[:plugin_conf_dir]}/10-python.conf to load the plugin" do
            is_expected.to contain_file('python.load').with(
              ensure: 'present',
              path: "#{options[:plugin_conf_dir]}/10-python.conf",
              content: %r{LoadPlugin python}
            )
          end

          it "Will create #{options[:plugin_conf_dir]}/python-config.conf" do
            is_expected.to contain_concat("#{options[:plugin_conf_dir]}/python-config.conf")
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
              content: %r{<Plugin "python">},
              target: "#{options[:plugin_conf_dir]}/python-config.conf",
              order: '00'
            )
          end

          it 'set default Python module path' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
              content: %r{ModulePath "/usr/local/lib/python2.7/dist-packages"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'Will create /etc/collectd.d/conf.d/python-config.conf' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_footer').with(
              content: %r{</Plugin>},
              target: "#{options[:plugin_conf_dir]}/python-config.conf",
              order: '99'
            )
          end
        end

        context ':ensure => present and multiple $modulepaths' do
          let :params do
            {
              modulepaths: ['/tmp/', '/data/']
            }
          end

          it 'will ensure the two directories are here' do
            is_expected.to contain_file('/tmp/')
            is_expected.to contain_file('/data/')
          end

          it 'will set two modulepath in the module conf' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
              content: %r{ModulePath "/tmp/"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
              content: %r{ModulePath "/data/"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end
        end

        context ':ensure => present and configure elasticsearch module' do
          let :params do
            {
              modules: {
                'elasticsearch' => {
                  'script_source' => 'puppet:///modules/myorg/elasticsearch_collectd_python.py',
                  'config'        => [{ 'Cluster' => 'ES-clust' }, { 'Cluster' => 'Another-ES-clust' }]
                },
                'foo' => {
                  'config' => [{ 'Verbose' => true, 'Bar' => '"bar"' }]
                },
                'alpha' => {
                  'config' => [{ 'Beta' => 4.2, 'Gamma' => 'b', 'Delta' => ['a', 4, 5] }]
                }
              }
            }
          end

          it 'imports elasticsearch module' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_elasticsearch_header').with(
              content: %r{Import "elasticsearch"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'includes elasticsearch module configuration' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_elasticsearch_config').with(
              content: %r{<Module "elasticsearch">},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'includes elasticsearch Cluster name' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_elasticsearch_config').with(
              content: %r{Cluster "ES-clust"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'includes second elasticsearch Cluster name' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_elasticsearch_config').with(
              content: %r{Cluster "Another-ES-clust"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'created collectd plugin file' do
            is_expected.to contain_file('elasticsearch.script').with(
              ensure: 'present',
              path: '/usr/local/lib/python2.7/dist-packages/elasticsearch.py'
            )
          end

          # test foo module
          it 'imports foo module' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_header').with(
              content: %r{Import "foo"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'includes foo module configuration' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(
              content: %r{<Module "foo">},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(content: %r{Verbose true})
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_foo_config').with(content: %r{Bar ""bar""})
          end

          it 'includes alpha module configuration' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_alpha_config').with(
              content: %r{<Module "alpha">},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_alpha_config').with(content: %r{Beta 4.2})
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_alpha_config').with(content: %r{Delta "a" 4 5})
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_alpha_config').with(content: %r{Gamma "b"})
          end
        end

        context 'two modules with same python module should not clash' do
          let :params do
            {
              modules: {
                'One' => {
                  'module' => 'funky',
                  'config' => [{ 'Verbose' => true }, { 'Junk' => 'help' }]
                },
                'Two' => {
                  'module' => 'funky',
                  'config' => [{ 'Junk' => 'morehelp' }]
                }
              }
            }
          end

          it 'import funky module' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_funky_header').with(
              content: %r{Import "funky"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'open instance One of module' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_One_config').with(
              content: %r{<Module "funky">},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'open instance Two of module' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_Two_config').with(
              content: %r{<Module "funky">},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'configure instance One of module' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_One_config').with(
              content: %r{Verbose true},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'configure instance Two of module' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_Two_config').with(
              content: %r{Junk "morehelp"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'close funky module instance One' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_One_config').with(
              content: %r{</Module>},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end

          it 'close funky module instance Two' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_Two_config').with(
              content: %r{</Module>},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )
          end
        end

        context 'allow changing module path' do
          let :params do
            {
              modulepaths: ['/var/lib/collectd/python', '/usr/collectd'],
              modules: {
                'elasticsearch' => {
                  'script_source' => 'puppet:///modules/myorg/elasticsearch_collectd_python.py',
                  'config'        => [{ 'Cluster' => 'ES-clust' }],
                  'modulepath'    => '/var/lib/collectd/python'
                }
              }
            }
          end

          it 'ensures that each directory on $modulepaths exits' do
            is_expected.to contain_file('/var/lib/collectd/python').with(ensure: 'directory')

            is_expected.to contain_file('/usr/collectd').with(ensure: 'directory')
          end

          it 'set default Python module paths' do
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
              content: %r{ModulePath "/var/lib/collectd/python"},
              target: "#{options[:plugin_conf_dir]}/python-config.conf"
            )

            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(content: %r{ModulePath "/usr/collectd"})

            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(content: %r{ModulePath "/var/lib/collectd/python"})
          end

          it 'created collectd plugin file' do
            is_expected.to contain_file('elasticsearch.script').
              with(ensure: 'present',
                   path: '/var/lib/collectd/python/elasticsearch.py')
          end
        end

        context ':ensure => present and custom python config location' do
          let :params do
            {
              conf_name: 'custom-location-config.conf'
            }
          end

          it "Will create #{options[:plugin_conf_dir]}/custom-location-config.conf" do
            is_expected.to contain_concat("#{options[:plugin_conf_dir]}/custom-location-config.conf")
            is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(
              content: %r{<Plugin "python">},
              target: "#{options[:plugin_conf_dir]}/custom-location-config.conf",
              order: '00'
            )
          end
        end
      end

      context 'change globals parameter' do
        let :params do
          {
            globals: false
          }
        end

        it 'will change $globals settings' do
          is_expected.to contain_file('python.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-python.conf",
            content: %r{Globals false}
          )
        end
      end

      context 'allow passing shared options for all modules' do
        let :params do
          {
            logtraces: true,
            interactive: true,
            encoding: 'utf-8'
          }
        end

        it 'sets options' do
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(content: %r{LogTraces true})
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(content: %r{Interactive true})
          is_expected.to contain_concat__fragment('collectd_plugin_python_conf_header').with(content: %r{Encoding utf-8})
        end
      end

      context ':ensure => absent' do
        let(:title) { 'elasticsearch' }
        let :params do
          {
            ensure: 'absent',
            modules: {
              'elasticsearch' => {
                'script_source' => 'puppet:///modules/myorg/elasticsearch_collectd_python.py',
                'config'        => [{ 'Cluster' => 'ES-clust' }]
              }
            }
          }
        end

        it "will remove #{options[:plugin_conf_dir]}/10-python.conf" do
          is_expected.to contain_file('python.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-python.conf",
            content: %r{LoadPlugin python}
          )
        end

        it "won't create #{options[:plugin_conf_dir]}/python-config.conf (no modules defined)" do
          is_expected.not_to contain_concat__fragment('collectd_plugin_python_conf_header').with(
            ensure: 'absent',
            target: "#{options[:plugin_conf_dir]}/python-config.conf",
            order: '00'
          )
        end
      end
    end
  end
end
