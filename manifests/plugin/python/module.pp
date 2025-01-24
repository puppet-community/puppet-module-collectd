# Single module definition
define collectd::plugin::python::module (
  Array[Hash[String,Variant[String,Boolean,Numeric,Array[Variant[Boolean,String,Numeric]]]]] $config = [],
  Enum['present','absent'] $ensure = 'present',
  String $module = $title,
  Optional[String] $module_import = undef,
  Optional[Stdlib::Absolutepath] $modulepath = undef,
  Optional[String] $script_source = undef,
) {
  include collectd
  include collectd::plugin::python

  $module_dir = $modulepath ? {
    undef   => $collectd::python_dir,
    default => $modulepath
  }

  $_module_import = $module_import ? {
    undef   => $module,
    default => $module_import
  }

  if $script_source {
    file { "${module}.script":
      ensure  => $ensure,
      path    => "${module_dir}/${module}.py",
      owner   => $collectd::config_owner,
      group   => $collectd::config_group,
      mode    => $collectd::config_mode,
      source  => $script_source,
      require => File[$module_dir],
      notify  => Service[$collectd::service_name],
    }
  }

  if $ensure == 'present' {
    # Exactly one per module.
    ensure_resource('concat::fragment',"collectd_plugin_python_conf_${module}_header",
      {
        'order'   => "50_${module}_00",
        'target'  => $collectd::plugin::python::python_conf,
        'content' => epp('collectd/plugin/python/module.conf_header.epp',
          {
            'module_import' => $_module_import,
          },
        ),
      }
    )

    # Possibly many per instance of a module configuration.
    concat::fragment { "collectd_plugin_python_conf_${title}_config":
      order   => "50_${module}_50",
      target  => $collectd::plugin::python::python_conf,
      content => epp('collectd/plugin/python/module.conf_config.epp',
        {
          'title'  => $title,
          'config' => $config,
          'module' => $module,
        },
      ),
    }
  }
}
