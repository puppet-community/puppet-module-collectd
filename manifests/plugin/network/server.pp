#
define collectd::plugin::network::server (
  Enum['present', 'absent'] $ensure                         = 'present',
  Optional[String] $username                                = undef,
  Optional[String] $password                                = undef,
  Optional[Stdlib::Port] $port                              = undef,
  Optional[Collectd::Network::SecurityLevel] $securitylevel = undef,
  Optional[String] $interface                               = undef,
  Optional[Boolean] $forward                                = undef,
  Optional[Integer[1]] $resolveinterval                     = undef,
  String[1] $server                                         = $name,
) {
  include collectd
  include collectd::plugin::network

  $conf_dir = $collectd::plugin_conf_dir

  file { "${conf_dir}/network-server-${name}.conf":
    ensure  => $ensure,
    mode    => $collectd::config_mode,
    owner   => $collectd::config_owner,
    group   => $collectd::config_group,
    content => template('collectd/plugin/network/server.conf.erb'),
    notify  => Service[$collectd::service_name],
  }
}
