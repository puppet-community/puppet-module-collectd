# Collectd module for Puppet

[![Build Status](https://github.com/voxpupuli/puppet-collectd/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-collectd/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-collectd/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-collectd/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/collectd.svg)](https://forge.puppetlabs.com/puppet/collectd)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/collectd.svg)](https://forge.puppetlabs.com/puppet/collectd)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/collectd.svg)](https://forge.puppetlabs.com/puppet/collectd)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/collectd.svg)](https://forge.puppetlabs.com/puppet/collectd)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-collectd)
[![Apache-2.0 License](https://img.shields.io/github/license/voxpupuli/puppet-collectd.svg)](LICENSE)

## Description

Puppet module for configuring collectd and plugins.

## Usage

The simplest use case is to use all of the configurations in
the default `collectd.conf` file shipped with collectd. This can
be done by simply including the class:

```puppet
include collectd
```

Collectd is most useful when configured with customized plugins.
This is accomplished by removing the default `collectd.conf` file
and replacing it with a file that includes all alternative
configurations. Configure a node with the following class
declaration:

```puppet
class { 'collectd':
  purge           => true,
  recurse         => true,
  purge_config    => true,
  minimum_version => '5.4',
}
```

Set `purge`, `recurse`, and `purge_config` to `true` in order to override
the default configurations shipped in `collectd.conf` and use
custom configurations stored in `conf.d`. From here you can set up
additional plugins as shown below.

Specifying the `version` or `minimum_version` of collectd as shown above reduces
the need for two puppet runs to converge. See
[Puppet needs two runs to correctly write my conf, why?](#puppet-needs-two-runs-to-correctly-write-my-conf-why)
below.

Hiera example in YAML of passing `install_options` to the package resource for
managing the collectd package. This parameter must be an array.

```yaml
collectd::package_install_options:
  - '--nogpgcheck'
```

## Simple Plugins

Example of how to load plugins with no additional configuration:

```puppet
collectd::plugin { 'battery': }
```

Where `battery` is the name of the plugin.

**Note:** this should only be done in the case of a class for the plugin
not existing in this module.

## Repo management

The module will enable a repo by default.

On CentOS that will be EPEL:
* http://rpms.famillecollet.com/rpmphp/zoom.php?rpm=collectd

On Ubuntu that'll be the CollectD PPA:
* https://launchpad.net/~collectd/+archive/ubuntu/collectd-5.5

### Public key keyserver
In case you need to change the server where to download the public key from for
whatever reason (AKA: server is down) you can use the parameter
`$package_keyserver`

### CI Packages

Recently, Collectd CI packages are also avaliable from the CI repo

More information is avaliable here:
* https://github.com/collectd/collectd-ci

You can choose the CI repo with the `$ci_package_repo` parameter.

`$ci_package_repo` has to match '5.4', '5.5', '5.6', '5.7' or 'master' (RC for next release) as
these are the current branches being built in the Collectd CI.

## Configurable Plugins

Parameters will vary widely between plugins. See the collectd
documentation for each plugin for configurable attributes.

* `aggregation`  (see [collectd::plugin::aggregation](#class-collectdpluginaggregation)
  below)
* `amqp`  (see [collectd::plugin::amqp](#class-collectdpluginamqp) below)
* `apache`  (see [collectd::plugin::apache](#class-collectdpluginapache) below)
* `battery`  (see [collectd::plugin::battery](#class-collectdpluginbattery) below)
* `bind`  (see [collectd::plugin::bind](#class-collectdpluginbind) below)
* `ceph`  (see [collectd::plugin::ceph](#class-ceph) below)
* `cgroups` (see [collectd::plugin::cgroups](#class-collectdplugincgroups) below)
* `chain`  (see [collectd::plugin::chain](#class-chain) below)
* `conntrack`  (see [collectd::plugin::conntrack](#class-conntrack) below)
* `cpu`  (see [collectd::plugin::cpu](#class-collectdplugincpu) below)
* `cpufreq`  (see [collectd::plugin::cpufreq](#class-collectdplugincpufreq) below)
* `csv`  (see [collectd::plugin::csv](#class-collectdplugincsv) below)
* `cuda` (see [collectd::plugin::cuda](#class-collectdplugincuda) below)
* `curl` (see [collectd::plugin::curl](#class-collectdplugincurl) below)
* `curl_json` (see [collectd::plugin::curl_json](#class-collectdplugincurl_json)
  below)
* `dbi`  (see [collectd::plugin::dbi](#class-collectdplugindbi) below)
* `df`  (see [collectd::plugin::df](#class-collectdplugindf) below)
* `disk` (see [collectd::plugin::disk](#class-collectdplugindisk) below)
* `dns` (see [collectd::plugin::dns](#class-collectdplugindns) below)
* `dcpmm` (see [collectd::plugin::dcpmm](#class-collectdplugindcpmm) below)
* `dpdk_telemetry` (see [collectd::plugin::dpdk_telemetry](#class-collectdplugindpdk_telemetry) below)
* `entropy`  (see [collectd::plugin::entropy](#class-collectdpluginentropy) below)
* `exec`  (see [collectd::plugin::exec](#class-collectdpluginexec) below)
* `ethstat`  (see [collectd::plugin::ethstat](#class-collectdpluginethstat) below)
* `fhcount` (see [collectd::plugin::fhcount](#class-collectdpluginfhcount) below)
* `filecount` (see [collectd::plugin::filecount](#class-collectdpluginfilecount)
  below)
* `filter`  (see [collectd::plugin::filter](#class-collectdpluginfilter) below)
* `genericjmx` (see [collectd::plugin::genericjmx](#class-collectdplugingenericjmx)
  below)
* `hddtemp` (see [collectd::plugin::hddtemp](#class-collectdpluginhddtemp) below)
* `hugepages` (see [collectd::plugin::hugepages](#class-collectdpluginhugepages) below)
* `intel_pmu` (see [collectd::plugin::intel_pmu](#class-collectdpluginintel_pmu) below)
* `intel_rdt` (see [collectd::plugin::intel_rdt](#class-collectdpluginintel_rdt) below)
* `interface` (see [collectd::plugin::interface](#class-collectdplugininterface)
  below)
* `ipc` (see [collectd::plugin::ipc](#class-collectdpluginipc) below)
* `ipmi` (see [collectd::plugin::ipmi](#class-collectdpluginipmi) below)
* `iptables` (see [collectd::plugin::iptables](#class-collectdpluginiptables) below)
* `iscdhcp` (see [collectd::plugin::iscdhcp](#class-collectdpluginiscdhcp) below)
* `irq` (see [collectd::plugin::irq](#class-collectdpluginirq) below)
* `java` (see [collectd::plugin::java](#class-collectdpluginjava) below)
* `load` (see [collectd::plugin::load](#class-collectdpluginload) below)
* `logfile` (see [collectd::plugin::logfile](#class-collectdpluginlogfile) below)
* `virt` (see [collectd::plugin::virt](#class-collectdpluginvirt) below)
* `lvm` (see [collectd::plugin::lvm](#class-collectdpluginlvm) below)
* `mcelog` (see [collectd::plugin::mcelog](#class-collectdpluginmcelog) below)
* `memcached`(see [collectd::plugin::memcached](#class-collectdpluginmemcached)
  below )
* `memory`(see [collectd::plugin::memory](#class-collectdpluginmemory) below )
* `modbus` (see [collectd::plugin::modbus](#class-collectdpluginmodbus) below)
* `mongodb`(see [collectd::plugin::mongodb](#class-collectdpluginmongodb) below )
* `mysql` (see [collectd::plugin::mysql](#class-collectdpluginmysql) below)
* `netlink` (see [collectd::plugin::netlink](#class-collectdpluginnetlink) below)
* `network` (see [collectd::plugin::network](#class-collectdpluginnetwork) below)
* `nfs`  (see [collectd::plugin::nfs](#class-collectdpluginnfs) below)
* `nginx` (see [collectd::plugin::nginx](#class-collectdpluginnginx) below)
* `ntpd` (see [collectd::plugin::ntpd](#class-collectdpluginntpd) below)
* `numa` (see [collectd::plugin::numa](#class-collectdpluginnuma) below)
* `nut` (see [collectd::plugin::nut](#class-collectdpluginnut) below)
* `openldap` (see [collectd::plugin::openldap](#class-collectdpluginopenldap) below)
* `openvpn` (see [collectd::plugin::openvpn](#class-collectdpluginopenvpn) below)
* `pcie_errors` (see [collectd::plugin::pcie_errors](#class-collectdpluginpcie_errors) below)
* `perl` (see [collectd::plugin::perl](#class-collectdpluginperl) below)
* `ping` (see [collectd::plugin::ping](#class-collectdpluginping) below)
* `postgresql` (see [collectd::plugin::postgresql](#class-collectdpluginpostgresql)
  below)
* `processes` (see [collectd::plugin:processes](#class-collectdpluginprocesses) below)
* `protocols` (see [collectd::plugin:protocols](#class-collectdpluginprotocols) below)
* `python` (see [collectd::plugin::python](#class-collectdpluginpython) below)
* `redis` (see [collectd::plugin::redis](#class-collectdpluginredis) below)
* `rabbitmq` (see [collectd-rabbitmq](https://pypi.python.org/pypi/collectd-rabbitmq)
  and [below](#class-collectdpluginrabbitmq) for implementation notes
* `rrdcached` (see [collectd::plugin::rrdcached](#class-collectdpluginrrdcached)
  below)
* `rrdtool` (see [collectd::plugin::rrdtool](#class-collectdpluginrrdtool) below)
* `sensors` (see [collectd::plugin::sensors](#class-collectdpluginsensors) below)
* `smart` (see [collectd::plugin::smart](#class-collectdpluginsmart) below)
* `snmp` (see [collectd::plugin::snmp](#class-collectdpluginsnmp) below)
* `snmp_agent` (see [collectd::plugin::snmp_agent](#class-collectdpluginsnmpagent) below)
* `statsd` (see [collectd::plugin::statsd](#class-collectdpluginstatsd) below)
* `swap` (see [collectd::plugin::swap](#class-collectdpluginswap) below)
* `syslog` (see [collectd::plugin::syslog](#class-collectdpluginsyslog) below)
* `tail` (see [collectd::plugin::tail](#class-collectdplugintail) below)
* `target_v5upgrade` (see [collectd::plugin::target_v5upgrade](#class-collectdplugintarget_v5upgrade)
  below)
* `tcpconns` (see [collectd::plugin::tcpconns](#class-collectdplugintcpconns) below)
* `thermal` (see [collectd::plugin::thermal](#class-collectdpluginthermal) below)
* `threshold` (see [collect::plugin::threshold](#class-collectdpluginthreshold) below)
* `unixsock` (see [collectd::plugin::unixsock](#class-collectdpluginunixsock) below)
* `uptime` (see [collectd::plugin::uptime](#class-collectdpluginuptime) below)
* `users` (see [collectd::plugin::users](#class-collectdpluginusers) below)
* `uuid` (see [collectd::plugin::uuid](#class-collectdpluginuuid) below)
* `varnish` (see [collectd::plugin::varnish](#class-collectdpluginvarnish) below)
* `vmem` (see [collectd::plugin::vmem](#class-collectdpluginvmem) below)
* `write_graphite` (see [collectd::plugin::write_graphite](#class-collectdpluginwrite_graphite)
 below)
* `write_http` (see [collectd::plugin::write_http](#class-collectdpluginwrite_http)
  below)
* `write_kafka` (see [collectd::plugin::write_kafka](#class-collectdpluginwrite_kafka)
  below)
* `write_log` (see [collectd::plugin::write_log](#class-collectdpluginwrite_log)
  below)
* `write_prometheus` (see [collectd::plugin::write_prometheus](#class-collectdpluginwrite_prometheus)
  below)
* `write_network` (see [collectd::plugin::write_network](#class-collectdpluginwrite_network)
  below)
* `write_riemann` (see [collectd::plugin::write_riemann](#class-collectdpluginwrite_riemann)
  below)
* `write_sensu` (see [collectd::plugin::write_sensu](#class-collectdpluginwrite_sensu)
  below)
* `write_tsdb` (see [collectd::plugin::write_tsdb](#class-collectdpluginwrite_tsdb)
  below)
* `zfs_arc` (see [collectd::plugin::zfs_arc](#class-collectdpluginzfs_arc) below)
* `zookeeper` (see
  [collectd::plugin::zookeeper](#class-collectdzookeeper) below)

### Class: `collectd::plugin::aggregation`

```puppet
collectd::plugin::aggregation::aggregator { 'cpu':
    plugin           => 'cpu',
    agg_type         => 'cpu',
    groupby          => ['Host', 'TypeInstance',],
    calculateaverage => true,
}
```

You can as well configure this plugin with a parameterized class :

```puppet
class { 'collectd::plugin::aggregation':
  aggregators => {
    'cpu' => {
      plugin           => 'cpu',
      agg_type         => 'cpu',
      groupby          => ["Host", "TypeInstance",],
      calculateaverage => true,
    },
  },
}
```

### Class: `collectd::plugin::amqp`

```puppet
class { 'collectd::plugin::amqp':
  amqphost => '127.0.0.1',
  amqpvhost => 'myvirtualhost',
  graphiteprefix => 'collectdmetrics',
  amqppersistent => true,
}
```

### Class: `collectd::plugin::apache`

```puppet
class { 'collectd::plugin::apache':
  instances => {
    'apache80'     => {
      'url'      => 'http://localhost/mod_status?auto',
      'user'     => 'collectd',
      'password' => 'hoh2Coo6'
    },
    'lighttpd8080' => {
      'url' => 'http://localhost:8080/mod_status?auto'
    }
  },
}
```

### Class: `collectd::plugin::battery`

```puppet
class { 'collectd::plugin::battery':
  interval => 30,
  values_percentage => true,
  report_degraded => true,
  query_state_fs => true,
}
```

### Class: `collectd::plugin::bind`

```puppet
class { 'collectd::plugin::bind':
  url    => 'http://localhost:8053/',
}
```

### Class: `collectd::plugin::ceph`

```puppet
class { 'collectd::plugin::ceph':
  daemons        => [
    '[clustername]-osd.0',
    '[clustername]-osd.1',
    '[clustername]-osd.2',
    '[clustername]-mon.[hostname].asok'
  ],
  manage_package => true
}
```

### Class: `collectd::plugin::cgroups`

 See [collectd plugin_cgroups documentation](https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_cgroups)
 for more details.

```puppet
class { 'collectd::plugin::cgroups':
  ignore_selected => true,
  cgroups         => ['array', 'of', 'paths']
}
```

### Class: `collectd::plugin::chain`

```puppet
class { 'collectd::plugin::chain':
    chainname     => "PostCache",
    defaulttarget => "write",
    rules         => [
      {
        'match'   => {
          'type'    => 'regex',
          'matches' => {
            'Plugin'         => "^cpu$",
            'PluginInstance' => "^[0-9]+$",
          },
        },
        'targets' => [
          {
            'type'       => "write",
            'attributes' => {
              "Plugin" => "aggregation",
            },
          },
          {
            'type' => "stop",
          },
        ],
      },
    ],
  }
```

### Class: `collectd::plugin::conntrack`

```puppet
class { 'collectd::plugin::conntrack':
}
```

### Class: `collectd::plugin::cpu`

* `reportbystate` available from collectd version >= 5.5
* `reportbycpu` available from collectd version >= 5.5
* `valuespercentage` available from collectd version >= 5.5
* `reportnumcpu` available from collectd version >= 5.6

 See [collectd plugin_cpu documentation](https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_cpu)
 for more details.

```puppet
class { 'collectd::plugin::cpu':
  reportbystate => true,
  reportbycpu => true,
  valuespercentage => true,
}
```

### Class: `collectd::plugin::cpufreq`

```puppet
class { 'collectd::plugin::cpufreq':
}
```

### Class: `collectd::plugin::csv`

```puppet
class { 'collectd::plugin::csv':
  datadir    => '/etc/collectd/var/lib/collectd/csv',
  storerates => false,
}
```


### Class: `collectd::plugin::cuda`

```puppet
class { 'collectd::plugin::cuda':
}
```


### Class: `collectd::plugin::curl`

```puppet
collectd::plugin::curl::page {
  'stock_quotes':
    url      => 'http://finance.google.com/finance?q=NYSE%3AAMD',
    user     => 'foo',
    password => 'bar',
    matches  => [
      {
        'dstype'   => 'GaugeAverage',
        'instance' => 'AMD',
        'regex'    => ']*> *([0-9]*\\.[0-9]+) *',
        'type'     => 'stock_value',
      }],
}
```

You can as well configure this plugin with a parameterized class :

```puppet
class { 'collectd::plugin::curl':
  pages => {
    'stock_GM' => {
      url      => 'http://finance.google.com/finance?q=NYSE%3AGM',
      user     => 'foo',
      password => 'bar',
      matches  => [
        {
          'dstype'   => 'GaugeAverage',
          'instance' => 'AMD',
          'regex'    => ']*> *([0-9]*\\.[0-9]+) *',
          'type'     => 'stock_value',
        },
      ],
    },
  },
}
```

### Class: `collectd::plugin::curl_json`

```puppet
collectd::plugin::curl_json {
  'rabbitmq_overview':
    url        => 'http://localhost:55672/api/overview',
    host       => 'rabbitmq.example.net',
    instance   => 'rabbitmq_overview',
    interval   => '300',
    user       => 'user',
    password   => 'password',
    digest     => 'false',
    verifypeer => 'false',
    verifyhost => 'false',
    cacert     => '/path/to/ca.crt',
    header     => 'Accept: application/json',
    post       => '{secret: \"mysecret\"}',
    timeout    => '1000',
    keys       => {
      'message_stats/publish' => {
        'type'     => 'gauge',
        'instance' => 'overview',
      },
    }
}
```

### Class: `collectd::plugin::dbi`

```puppet
collectd::plugin::dbi::database{'monitoring_node1':
  driver       => 'mysql',
  driveroption => {
    'host' => 'hostname',
    'username' => 'user',
    'password' => 'password',
    'dbname'   => 'monitoring'
  },
  query    => ['log_delay'],
}
collectd::plugin::dbi::query{'log_delay':
  statement => 'SELECT * FROM log_delay_repli;',
  results   => [{
    type           => 'gauge',
    instanceprefix => 'log_delay',
    instancesfrom  => 'inet_server_port',
    valuesfrom     => 'log_delay',
  }],
}
```

You can as well configure this plugin as a parameterized class :

```puppet
class { 'collectd::plugin::dbi':
  package   => 'libdbd-mysql',
  databases => {
    'monitoring_node1' => {
      driver       => 'mysql',
      driveroption => {
        'host' => 'hostname',
        'username' => 'user',
        'password' => 'password',
        'dbname'   => 'monitoring'
      },
      query    => ['log_delay'],
    }
  },
}
```

### Class: `collectd::plugin::df`

```puppet
class { 'collectd::plugin::df':
  devices        => ['proc','sysfs'],
  mountpoints    => ['/u'],
  fstypes        => ['nfs','tmpfs','autofs','gpfs','proc','devpts'],
  ignoreselected => true,
}
```

### Class: `collectd::plugin::disk`

```puppet
class { 'collectd::plugin::disk':
  disks          => ['/^dm/'],
  ignoreselected => true,
  udevnameattr   => 'DM_NAME',
}
```

### Class: `collectd::plugin::dns`

```puppet
class { 'collectd::plugin::dns':
}
```

#### Parameters

See collectd [documentation](https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_dns).

##### ensure

Optional. String that must be 'present' or 'absent'.

- *Default*: 'present'

##### ignoresource

Optional. String of IP address to ignore.

- *Default*: undef

##### interface

String of interface to use. May be interface identifier such as 'eth0' or 'any'.

- *Default*: 'any'

##### interval

Numeric for interval in seconds. Changing this can be a disaster. Consult the documentation.

- *Default*: undef

##### manage_package

Boolean to determine if system package for collectd's dns plugin should be
managed. If set to true, you must specify the package name for any unsupported
OS.

- *Default*: false

##### package_name

String for name of package. A value of 'USE_DEFAULTS' will set the value based
on the platform. This is necessary when setting manage_package on an
unsupported platform.

- *Default*: 'USE_DEFAULTS'

##### selectnumericquerytypes

Boolean for SelectNumericQueryTypes configuration option.

- *Default*: true

#### Class: `collectd::plugin::dpdk_telemetry`

```puppet
class { 'collectd::plugin::dpdk_telemetry':
  client_socket_path => '/var/run/.client',
  dpdk_socket_path   => '/var/run/dpdk/rte/telemetry',
}
```

#### Class: `collectd::plugin::dcpmm`

```puppet
class { 'collectd::plugin::dcpmm':
  interval             => 10.0,
  collect_health       => false,
  collect_perf_metrics => true,
  enable_dispatch_all  => false,
}
```

#### Class: `collectd::plugin::entropy`

```puppet
class { 'collectd::plugin::entropy':
}
```

#### Class: `collectd::plugin::exec`

```puppet
collectd::plugin::exec::cmd {
  'dummy':
    user => nobody,
    group => nogroup,
    exec => ["/bin/echo", "PUTVAL myhost/foo/gauge-flat N:1"],
}
```

You can also configure this plugin with a parameterized class:

```puppet
class { 'collectd::plugin::exec':
  commands => {
    'dummy1' => {
      user  => nobody,
      group => nogroup,
      exec  => ["/bin/echo", "PUTVAL myhost/foo/gauge-flat1 N:1"],
    },
    'dummy2' => {
      user  => nobody,
      group => nogroup,
      exec  => ["/bin/echo", "PUTVAL myhost/foo/gauge-flat2 N:1"],
    },
  }
}
```

#### Class: `collectd::plugin::ethstat`

```puppet
class { 'collectd::plugin::ethstat':
  interfaces => [ 'eth0', 'eth1'],
  maps       => [
    '"rx_csum_offload_errors" "if_rx_errors" "checksum_offload"', '"multicast" "if_multicast"'
  ],
  mappedonly => false,
}
```

#### Class: `collectd::plugin::fhcount`

```puppet
class { 'collectd::plugin::fhcount':
  valuesabsolute   => true,
  valuespercentage => false,
}
```

#### Class: `collectd::plugin::fscache`

```puppet
class { 'collectd::plugin::fscache':
}
```

#### Class: `collectd::plugin::filecount`

```puppet
collectd::plugin::filecount::directory {'foodir':
  path          => '/path/to/dir',
  pattern       => '*.conf',
  mtime         => '-5m',
  recursive     => true,
  includehidden => false
}
```

You can also configure this plugin with a parameterized class:

```puppet
class { 'collectd::plugin::filecount':
  directories => {
    'foodir' => {
      'path'          => '/path/to/dir',
      'pattern'       => '*.conf',
      'mtime'         => '-5m',
      'recursive'     => true,
      'includehidden' => false
      },
  },
}
```

For backwards compatibility:

```puppet
class { 'collectd::plugin::filecount':
  directories => {
    'active'   => '/var/spool/postfix/active',
    'incoming' => '/var/spool/postfix/incoming'
  },
}
```

#### Class: `collectd::plugin::filter`

The filter plugin implements the powerful filter configuration of collectd.
For further details have a look on the [collectd manpage](https://collectd.org/documentation/manpages/collectd.conf.5.shtml#filter_configuration).

##### Parameters

* `ensure` (`"ensure"`,`"absent"`): Ob absent it will remove all references of
  the filter plugins. `Note`: The Chain config needs to be purged by the chain
  define.
* `precachechain` (String): The Name of the default Pre Chain.
* `postcachechain` (String): The Name of the default Post Chain.

##### Examples

###### Overwrite default chains

```puppet
class { 'collectd::plugin::filter':
    ensure          => 'present',
    precachechain   => 'PreChain',
    postcachechain  => 'PostChain',
}
```

###### Full Example

This Example will rename the hostname of the mysql plugin.

```puppet
include collectd::plugin::filter

# define default chains with default target
collectd::plugin::filter::chain { 'PreChain':
    target => 'return'
}
collectd::plugin::filter::chain { 'PostChain':
    target => 'write'
}

# create a third chain,
$chainname = 'MyAweseomeChain'
collectd::plugin::filter::chain { $chainname:
    ensure => present,
    target => 'return'
}

# add a new rule to chain
$rulename = 'MyAweseomeRule'
collectd::plugin::filter::rule { $rulename:
    chain => $chainname,
}

# add a new match rule, match metrics of the mysql plugin
collectd::plugin::filter::match { "Match mysql plugin":
    chain   => $chainname,
    rule    => $rulename,
    plugin  => 'regex',
    options => {
        'Plugin' => '^mysql',
    }
}

#rewrite hostname
collectd::plugin::filter::target{ "overwrite hostname":
    chain   => $chainname,
    rule    => $rulename,
    plugin  => 'set',
    options => {
        'Host' => 'hostname.domain',
    },
}

# hook the configured chain in the prechain
collectd::plugin::filter::target{ "1_prechain_jump_${chainname}":
    chain   => 'PreChain',
    plugin  => 'jump',
    options => {
        'Chain' => $chainname,
    },
}
```

#### Define: `collectd::plugin::filter::chain`

This define will create a new chain, which is required by targets, matches and rules.

##### Parameters

* `ensure` (`"ensure"`,`"absent"`): When set to absent it will remove the chain
  with all assigned rules, targets and matches.
* `target` (`'notification','replace','set','return','stop','write','jump'`):
  Optional. Set default target if no target has been applied. Strongly recommend
  for default chains.
* `target_options` (Hash): If target is specified, pass optional hash to define.

##### Example

see [collectd::plugin::filter](#class-collectdpluginfilter) above

#### Define: `collectd::plugin::filter::rule`

This define will add a new rule to a specific chain

##### Parameters

* `chain` (String): Assign to this chain.

##### Example

see [collectd::plugin::filter](#class-collectdpluginfilter) above

#### Define: `collectd::plugin::filter::target`

This define will add a target to a chain or rule.

##### Parameters

* `chain` (String): Assign to this chain.
* `plugin` (`'notification','replace','set','return','stop','write','jump'`): The
  plugin of the target.
* `options` (Hash): Optional parameters of the target plugin.
* `rule` (String): Optional. Assign to this rule. If not present, target will be
  applied at the end of chain without rule matching.

##### Example

see [collectd::plugin::filter](#class-collectdpluginfilter) above

#### Define: `collectd::plugin::filter::match`

This define will add a match rule.

##### Parameters

* `chain` (String): Assign to this chain.
* `rule` (String): Assign to this rule.
* `plugin` (`'regex','timediff','value','empty_counter','hashed'`): The plugin of
  the match.
* `options` (Hash): Optional parameters of the match plugin.

##### Example

see [collectd::plugin::filter](#class-collectdpluginfilter) above

#### Class: `collectd::plugin::genericjmx`

```puppet
include collectd::plugin::genericjmx

collectd::plugin::genericjmx::mbean {
  'garbage_collector':
    object_name     => 'java.lang:type=GarbageCollector,*',
    instance_prefix => 'gc-',
    instance_from   => ['name'],
    values          => [
      {
        mbean_type => 'invocations',
        table      => false,
        attribute  => 'CollectionCount',
      },
      {
        mbean_type      => 'total_time_in_ms',
        instance_prefix => 'collection_time',
        table           => false,
        attribute       => 'CollectionTime',
      },
    ];
}

collectd::plugin::genericjmx::connection {
  'java_app':
    host            => $fqdn,
    service_url     => 'service:jmx:rmi:///jndi/rmi://localhost:3637/jmxrmi',
    collect         => [ 'memory-heap', 'memory-nonheap','garbage_collector' ],
}

```

#### Class: `collectd::plugin::hddtemp`

```puppet
class { 'collectd::plugin::hddtemp':
  host => '127.0.0.1',
  port => 7634,
}
```

#### Class: `collectd::plugin::hugepages`

```puppet
class { 'collectd::plugin::hugepages':
  report_per_node_hp => true,
  report_root_hp     => true,
  values_pages       => true,
  values_bytes       => false,
  values_percentage  => false
}
```

#### Class: `collectd::plugin::intel_pmu`
```puppet
class { 'collectd::plugin::intel_pmu':
  report_hardware_cache_events => true,
  report_kernel_pmu_events => true,
  report_software_events => true,
}
```

#### Class: `collectd::plugin::mcelog`

```puppet
class { 'collectd::plugin::mcelog':
  mceloglogfile           => '/var/log/mcelog'
  memory                  => true
  mcelogclientsocket      => '/var/run/mcelog-client'
  persistentnotification  => true
}
```
#### Class: `collectd::plugin::intel_rdt`
```puppet
class { 'collectd::plugin::intel_rdt':
  cores => ['0-2' '3,4,6' '8-10,15']
}
```

#### Class: `collectd::plugin::interface`

```puppet
class { 'collectd::plugin::interface':
  interfaces     => ['lo'],
  ignoreselected => true
}
```

#### Class: `collectd::plugin::irq`

```puppet
class { 'collectd::plugin::irq':
  irqs           => ['7', '23'],
  ignoreselected => true,
}
```

#### Class: `collectd::plugin::ipc`

```puppet
class { 'collectd::plugin::ipc':
}
```

#### Class: `collectd::plugin::ipmi`

```puppet
class { 'collectd::plugin::ipmi':
  ignore_selected           => true,
  sensors                   => ['temperature'],
  notify_sensor_add         => true,
  notify_sensor_remove      => true,
  notify_sensor_not_present => true,
}
```

#### Class: `collectd::plugin::iptables`

```puppet
class { 'collectd::plugin::iptables':
  chains  => {
    'nat'    => 'In_SSH',
    'filter' => 'HTTP',
  },
  chains6 => {
    'filter' => 'HTTP6',
  },
}
```

#### Class: `collectd::plugin::iscdhcp`

```puppet
class { 'collectd::plugin::iscdhcp': }
```

#### Class: `collectd::plugin::java`

jvmarg options must be declared if declaring loadplugin, as the JVM must be
initialized prior to loading collectd java plugins.

```puppet
class { 'collectd::plugin::java':
  jvmarg      => ['arg1', 'arg2'],
  loadplugin  => {"plugin.name" => ["option line 1", "option line 2"]}
}
```

#### Class: `collectd::plugin::load`

```puppet
class { 'collectd::plugin::load':
}
```

#### Class: `collectd::plugin::logfile`

```puppet
class { 'collectd::plugin::logfile':
  log_level => 'warning',
  log_file => '/var/log/collected.log'
}
```

#### Class: `collectd::plugin::virt`

The interface_format parameter was introduced in collectd 5.0 and will
therefore be ignored (with a warning) when specified with older versions.

```puppet
class { 'collectd::plugin::virt':
  connection       => 'qemu:///system',
  interface_format => 'address'
}
```

#### Class: `collectd::plugin::lvm`

```puppet
class { 'collectd::plugin::lvm': }
```

#### Class: `collectd::plugin::memcached`

The plugin supports multiple instances specified via host+port and socket:

```puppet
class { 'collectd::plugin::memcached':
  instances => {
    'sessions1' => {
      'host' => '192.168.122.1',
      'port' => '11211',
    },
    'storage1' => {
      'host' => '192.168.122.1',
      'port' => '11212',
    },
    'sessions2' => {
      'socket'  => '/var/run/memcached.sessions.sock',
    },
    'storage2' => {
      'socket'  => '/var/run/memcached.storage.sock',
    },
  }
}
```

#### Class: `collectd::plugin::memory`

```puppet
class { 'collectd::plugin::memory':
}
```

#### Class: `collectd::plugin::modbus`

```puppet
class {'collectd::plugin::modbus':
  ensure => 'present',
  data   =>  {
    current_phase_a => {
      'type'          => 'gauge',
      'instance'      => 'current phase A',
      'register_base' => 1234,
      'register_type' => 'Float',
    }
  },
  hosts  => {
    meter123 => {
      'address'   => '127.0.0.1',
      'port'      => 502,
      'interval'  => 10,
      'slaves'    => {
        255 => {
          'instance' => 'power meter 255',
          'collect'  => ['current_phase_a'],
        }
      },
    }
  },
}
```

#### Class: `collectd::plugin::mysql`

```puppet
collectd::plugin::mysql::database { 'betadase':
  host        => 'localhost',
  username    => 'stahmna',
  password    => 'secret',
  port        => '3306',
  masterstats => true,
  wsrepstats  => true,
}
```

#### Class: `collectd::plugin::mongodb`

```puppet
class { 'collectd::plugin::mongodb':
  db_user => 'admin',
  db_pass => 'adminpass',
}
```

##### Parameters

* `ensure` (String): String that must be 'present' or 'absent'. *Default*: 'present'
* `interval` (String): Number of seconds that collectd pauses between data
  collection. *Default*: undef
* `db_host` (String): String that holds the IP of the MongoDB server. *Default*:
  '127.0.0.1'
* `db_user` (String): Required. String that specifies the user name of an account
  that can log into MongoDB
* `db_user` (String): Required. String that specifies the password of an account
  that can log into MongoDB
* `configured_dbs` (String): Optional. Array of Strings that lists the databases
  that should be monitored in addition to the "admin"
* `db_port` (String): Required if the configured_dbs parameter is set. Unused
  otherwise.  Integer that specifies with port MongoDB listens on.

```puppet
class { 'collectd::plugin::mongodb':
  db_host        => '127.0.0.1',
  db_user        => 'foo',
  db_pass        => 'bar',
  db_port        => '27017',
  configured_dbs => ['database', 'names'],
  collectd_dir   => '/collectd/module/path',
}
```

#### Class: `collectd::plugin::netlink`

```puppet
class { 'collectd::plugin::netlink':
  interfaces        => ['eth0', 'eth1'],
  verboseinterfaces => ['ppp0'],
  qdiscs            => ['"eth0" "pfifo_fast-1:0"', '"ppp0"'],
  classes           => ['"ppp0" "htb-1:10"'],
  filters           => ['"ppp0" "u32-1:0"'],
  ignoreselected    => false,
}
```

#### Class: `collectd::plugin::network`

```puppet
collectd::plugin::network::server{'hostname':
  port => 25826,
}

collectd::plugin::network::listener{'hostname':
  port => 25826,
}
```

You can as well configure this plugin with a parameterized class :

```puppet
class { 'collectd::plugin::network':
  timetolive    => '70',
  maxpacketsize => '42',
  forward       => false,
  reportstats   => true,
  servers       => { 'hostname' => {
    'port'          => '25826',
    'interface'     => 'eth0',
    'securitylevel' => '',
    'username'      => 'foo',
    'password'      => 'bar',},
  },
  listeners     => { 'hostname' => {
    'port'          => '25826',
    'interface'     => 'eth0',
    'securitylevel' => '',
    'authfile'      => '/etc/collectd/passwd',},
  },
}
```

#### Class: `collectd::plugin::nfs`

```puppet
class { 'collectd::plugin::nfs':
}
```

#### Class: `collectd::plugin::nginx`

```puppet
class { 'collectd::plugin::nginx':
  url      => 'https://localhost:8433',
  user     => 'stats',
  password => 'uleePi4A',
}
```

#### Class: `collectd::plugin::ntpd`

```puppet
class { 'collectd::plugin::ntpd':
  host           => 'localhost',
  port           => 123,
  reverselookups => false,
  includeunitid  => false,
}
```

#### Class: `collectd::plugin::numa`

```puppet
class { 'collectd::plugin::numa':
}
```

#### Class: `collectd::plugin::nut`

```puppet
class { 'collectd::plugin::nut':
    upss => [ 'ups@localhost:port' ]
}
```

#### Class: `collectd::plugin::openldap`

```puppet
class { 'collectd::plugin::openldap':
  instances => {
    'foo' => {
      'url' => 'ldap://localhost/'
    },
    'bar' => {
      'url' => 'ldaps://localhost/'
    }
  },
}
```

#### Class: `collectd::plugin::openvpn`

* `statusfile` (String or Array) Status file(s) to collect data from.
  (Default `/etc/openvpn/openvpn-status.log`)
* `improvednamingschema` (Bool) When enabled, the filename of the status file
  will be used as plugin instance and the client's "common name" will be used
  as type instance. This is required when reading multiple status files.
  (Default: `false`)
* `collectcompression` Sets whether or not statistics about the compression used
  by OpenVPN should be collected. This information is only available in single
  mode. (Default `true`)
* `collectindividualusers` Sets whether or not traffic information is collected
  for each connected client individually. If set to false, currently no traffic
  data is collected at all because aggregating this data in a save manner is
  tricky. (Default `true`)
* `collectusercount` When enabled, the number of currently connected clients
  or users is collected.  This is especially interesting when
  CollectIndividualUsers is disabled, but can be configured independently from
  that option. (Default `false`)

Watch multiple `statusfile`s:

```puppet
class { 'collectd::plugin::openvpn':
  statusfile             => [
    '/etc/openvpn/openvpn-status-tcp.log',
    '/etc/openvpn/openvpn-status-udp.log'
  ],
  collectindividualusers => false,
  collectusercount       => true,
}
```

Watch the single default `statusfile`:

```puppet
class { 'collectd::plugin::openvpn':
  collectindividualusers => false,
  collectusercount       => true,
}
```

#### Class: `collectd::plugin::pcie_errors`

```puppet
class { 'collectd::plugin::pcie_errors':
  source                   => undef,
  access_dir               => undef,
  report_masked            => false,
  persistent_notifications => false,
}
```

#### Class: `collectd::plugin::perl`

This class has no parameters and will load the actual perl plugin.
It will be automatically included if any `perl::plugin` is defined.

##### Example

```puppet
include collectd::plugin::perl
```

#### Define: `collectd::plugin::perl::plugin`

This define will load a new perl plugin.

##### Parameters

* `module` (String): name of perl module to load (mandatory)
* `enable_debugger` (False or String): whether to load the perl debugger. See
  *collectd-perl* manpage for more details.
* `include_dir` (String or Array): directories to add to *@INC*
* `provider` (`"package"`,`"cpan"`,`"file"` or `false`): method to get the
  plugin code
* `source` (String): this parameter is consumed by the provider to infer the
  source of the plugin code
* `destination` (String or false): path to plugin code if `provider` is `file`.
  Ignored otherwise.
* `order` (String containing numbers): order in which the plugin should be
  loaded. Defaults to `"00"`
* `config` (Hash): plugin configuration in form of a hash. This will be
  converted to a suitable structure understood by *liboconfig* which is the
  *collectd* configuration parser. Defaults to `{}`

##### Examples

###### Using a preinstalled plugin

```puppet
collectd::plugin::perl::plugin { 'foo':
    module          => 'Collectd::Plugins::Foo',
    enable_debugger => "",
    include_dir     => '/usr/lib/collectd/perl5/lib',
}
```

###### Using a plugin from a file from *source*

```puppet
collectd::plugin::perl::plugin { 'baz':
    module      => 'Collectd::Plugins::Baz',
    provider    => 'file',
    source      => 'puppet:///modules/myorg/baz_collectd.pm',
    destination => '/path/to/my/perl5/modules'
}
```

###### Using a plugin from cpan (requires the [puppet cpan module](https://forge.puppetlabs.com/meltwater/cpan))

```puppet
collectd::plugin::perl::plugin {
  'openafs_vos':
    module        => 'Collectd::Plugins::OpenAFS::VOS',
    provider      => 'cpan',
    source        => 'Collectd::Plugins::OpenAFS',
    config        => {'VosBin' => '/usr/afsws/etc/vos'},
}
```

###### Using a plugin from package source

```puppet
collectd::plugin::perl::plugin {
  'bar':
    module        => 'Collectd::Plugins::Bar',
    provider      => 'package',
    source        => 'perl-Collectd-Plugins-Bar',
    config        => {'foo' => 'bar'},
}
```

#### Class: `collectd::plugin::ping`

```puppet
class { 'collectd::plugin::ping':
    hosts => ['example.com'],
}
```

#### Class: `collectd::plugin::postgresql`

```puppet
collectd::plugin::postgresql::database{'monitoring_node1':
  name     => 'monitoring',
  port     => '5433',
  instance => 'node1',
  host     => 'localhost',
  user     => 'collectd',
  password => 'collectd',
  query    => 'log_delay',
}
collectd::plugin::postgresql::query{'log_delay':
  statement => 'SELECT * FROM log_delay_repli;',
  params    => ['database'],
  results   => [{
    type           => 'gauge',
    instanceprefix => 'log_delay',
    instancesfrom  => 'inet_server_port',
    valuesfrom     => 'log_delay',
  }],
}
collectd::plugin::postgresql::writer{'sqlstore':
  statement  => 'SELECT collectd_insert($1, $2, $3, $4, $5, $6, $7, $8, $9);',
  storerates => 'true',
}
```

You can as well configure this plugin as a parameterized class :

```puppet
class { 'collectd::plugin::postgresql':
  databases => {
    'postgres' => {
      'host'     => '/var/run/postgresql/',
      'user'     => 'postgres',
      'password' => 'postgres',
      'sslmode'  => 'disable',
      'query'    => [ 'query_plans', 'queries', 'table_states', 'disk_io' ],
    },
    'devdb' => {
      'host'     => 'host.example.com',
      'port'     => '5432',
      'user'     => 'postgres',
      'password' => 'secret',
      'sslmode'  => 'prefer',
    }
  }
}
```

#### Class: `collectd::plugin::powerdns`

You can either specify powerdns servers / recursors at once:

```puppet
class { 'collectd::plugin::powerdns':
  recursors => {
    'recursor1' => {
      'socket'  => '/var/run/my-socket',
      'collect' => ['cache-hits', 'cache-misses'],
    },
    'recursor2' => {}
  },
  servers => {
    'server1' => {
      'socket'  => '/var/run/my-socket',
      'collect' => ['latency', 'recursing-answers', 'recursing-questions'],
    }
  },
}
```

Or define single server / recursor:

```puppet
collectd::plugin::powerdns::recursor { 'my-recursor' :
  socket  => '/var/run/my-socket',
  collect => ['cache-hits', 'cache-misses'],
}
```

```puppet
collectd::plugin::powerdns::server { 'my-server' :
  socket  => '/var/run/my-socket',
  collect => ['latency', 'recursing-answers', 'recursing-questions'],
}
```

#### Class: `collectd::plugin::processes`

You can either specify processes / process matches at once:

```puppet
class { 'collectd::plugin::processes':
  processes => ['process1', 'process2'],
  process_matches => [
    { name => 'process-all', regex => 'process.*' }
  ],
}
```

Or define single processes / process matches:

```puppet
collectd::plugin::processes::process { 'collectd' : }
```

```puppet
collectd::plugin::processes::processmatch { 'elasticsearch' :
  regex => '.*java.*org.elasticsearch.bootstrap.Elasticsearch'
}
```

#### Class: `collectd::plugin::protocols`

* `values` is an array of `Protocol` names, `Protocol:ValueName` pairs, or a regex
* see `/proc/net/netstat` and `/proc/net/snmp` for a list of `Protocol` targets

 See [collectd.conf documentation](https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_protocols)
 for details

```puppet
class { 'collectd::plugin::protocols':
  values => ['/^Tcp:*/', '/^Udp:*/', 'Icmp:InErrors' ],
  ignoreselected => false,
}
```

#### Class: `collectd::plugin::python`
The plugin uses a fact `python_dir` to find the python load path for modules.
python or python3 must be installed as a pre-requisite for the this
fact to give a non-default value.

* `modulepaths` is an array of paths where will be Collectd looking for Python
  modules, Puppet will ensure that each of specified directories exists and it
  is owned by `root` (and `chmod 0750`). If you don't specify any `modulepaths`
  a default value for given distribution will be used.
* `modules` a Hash containing configuration of Python modules, where the key
  is the module name
* `globals` Unlike most other plugins, this one should set `Globals true`. This
  will cause collectd to export the name of all objects in the Python
  interpreter for all plugins to see. If you don't do this or your platform does
  not support it, the embedded interpreter will start anyway but you won't be
  able to load certain Python modules, e.g. "time".
* `interactive` when `true` it will launch an interactive Python interpreter
  that reads from and writes to the terminal (default: `false`)
* `logtraces` if a Python script throws an exception it will be logged by
  collectd with the name of the exception and the message (default: `false`)
* `conf_name` name of the file that will contain the python module configuration
  (default: `python-config.conf`)

 See [collectd-python documentation](https://collectd.org/documentation/manpages/collectd-python.5.shtml)
 for more details.

NOTE: Since `v3.4.0` the syntax of this plugin has changed. Make sure to update
your existing configuration. Now you can specify multiple Python modules at once:

```puppet
class { 'collectd::plugin::python':
  modulepaths => ['/usr/share/collectd/python'],
  modules     => {
    'elasticsearch' => {
      'script_source' => 'puppet:///modules/myorg/elasticsearch_collectd_python.py',
      'config'        => [{'Cluster' => 'elasticsearch'},],
    },
    'another-module' => {
      'config'        => [{'Verbose' => 'true'},],
    }
  }
  logtraces   => true,
  interactive => false,
}
```

When `script_source` provided, a file called `{module}.py` will be created in `$modulepath/$module.py`.

Or define single module:

```puppet
collectd::plugin::python::module {'zk-collectd':
  script_source => 'puppet:///modules/myorg/zk-collectd.py',
  config        => [
    {'Hosts'   => "localhost:2181",
     'Verbose' => true,
     'Values'  => ["abc","def"],
     'Name'    => 'My Name',
     'Limit'   => 4.5,
    }
  ]
}
```

The resulting configuration would be

```apache
Import "zk-collectd"
<Module "zk-collectd">
  Hosts "localhost:2181"
  Verbose true
  Values "abc" "def"
  Limit 4.5
</Module>
```

Each plugin might use different `modulepath`, however make sure that all paths
are included in `collectd::plugin::python` variable `modulepaths`. If no
`modulepath` is specified, OS default will be used.

```puppet
collectd::plugin::python::module {'my-module':
  modulepath    => '/var/share/collectd',
  script_source => 'puppet:///modules/myorg/my-module.py',
  config        => [
    {'Key'   => "value",
     'Value' => 3.4,
    }
  ]
}
```

#### Class: `collectd::plugin::redis`

```puppet
class { 'collectd::plugin::redis':
  nodes => {
    'node1' => {
      'host'     => 'localhost',
    },
    'node2' => {
      'host'     => 'node2.example.com',
      'port'     => '6380',
      'timeout'  => 3000,
    },
    'node3' => {
      'host'    => 'node3.example.com',
      'queries' => {
          'dbsize' => {
              'type'  => 'count',
              'query' => 'DBSIZE',
          },
      },
    },
  }
}
```

#### Class: `collectd::plugin::rabbitmq`

Please note the rabbitmq plugin provides a [types.db.custom](https://github.com/NYTimes/collectd-rabbitmq/blob/master/config/types.db.custom).
You will need to add this to [collectd::config::typesdb](https://github.com/voxpupuli/puppet-collectd/blob/master/manifests/config.pp#L18)
via hiera or in a manifest. Failure to set the types.db.custom content will
result in *no* metrics from the rabbitmq plugin.

The rabbitmq plugin has not been ported to python3 and will fail on CentOS 8 [#75](https://github.com/nytimes/collectd-rabbitmq/issues/75)

set typesdb to include the collectd-rabbitmq types.db.custom

```yaml
collectd::config::typesdb:
  - /usr/share/collectd/types.db
  - /usr/share/collect-rabbitmq/types.db.custom
```

```puppet
class { 'collectd::plugin::rabbitmq':
  config           => {
    'Username' => 'admin',
    'Password' => $admin_pass,
    'Scheme'   => 'https',
    'Port'     => '15671',
    'Host'     => $facts['fqdn'],
    'Realm'    => 'RabbitMQ Management',
  },
}
```

#### Class: `collectd::plugin::rrdcached`

```puppet
class { 'collectd::plugin::rrdcached':
  daemonaddress => 'unix:/var/run/rrdcached.sock',
  datadir       => '/var/lib/rrdcached/db/collectd',
}
```

#### Class: `collectd::plugin::rrdtool`

```puppet
class { 'collectd::plugin::rrdtool':
  datadir           => '/var/lib/collectd/rrd',
  createfilesasync  => false,
  rrarows           => 1200,
  rratimespan       => [3600, 86400, 604800, 2678400, 31622400],
  xff               => 0.1,
  cacheflush        => 900,
  cachetimeout      => 120,
  writespersecond   => 50
}
```

#### Class: `collectd::plugin::sensors`

```puppet
class {'collectd::plugin::sensors':
  sensors        => ['sensors-coretemp-isa-0000/temperature-temp2', 'sensors-coretemp-isa-0000/temperature-temp3'],
  ignoreselected => false,
}
```

#### Class: `collectd::plugin::smart`

```puppet
class { 'collectd::plugin::smart':
  disks          => ['/^dm/'],
  ignoreselected => true,
}
```

#### Class: `collectd::plugin::snmp`

```puppet
class {'collectd::plugin::snmp':
  data  =>  {
    amavis_incoming_messages => {
      'type'         => 'counter',
      'table'        => false,
      'instance'     => 'amavis.inMsgs',
      'values'       => ['AMAVIS-MIB::inMsgs.0'],
      'ignore'       => [ '00:00', '*IgnoreString' ],
      'invert_match' => false,
    }
  },
  hosts => {
    debianvm => {
      'address'   => '127.0.0.1',
      'version'   => 2,
      'community' => 'public',
      'collect'   => ['amavis_incoming_messages'],
      'interval'  => 10
    }
  },
}
```

```puppet
class { 'collectd::plugin::snmp':
  data  => {
    hc_octets => {
      'type'     => 'if_octets',
      'table'    => true,
      'instance' => 'IF-MIB::ifName',
      'values'   => ['IF-MIB::ifHCInOctets', 'IF-MIB::ifHCOutOctets'],
    },
  },
  hosts => {
    router => {
      'address'            => '192.0.2.1',
      'version'            => 3,
      'security_level'     => 'authPriv',
      'username'           => 'collectd',
      'auth_protocol'      => 'SHA',
      'auth_passphrase'    => 'mekmitasdigoat',
      'privacy_protocol'   => 'AES',
      'privacy_passphrase' => 'mekmitasdigoat',
      'collect'            => ['hc_octets'],
      'interval'           => 10,
    },
  },
}
```
#### Class: `collectd::plugin::snmp_agent`

```puppet
class {'collectd::plugin::snmp_agent':
  table => {
    ifTable => {
      'indexoid' => 'IF-MIB::ifIndex',
      'sizeoid' => 'IF-MIB::ifNumber',
      data => [{
        ifDescr => {
          'plugin' => 'interface',
          'oids' => 'IF-MIB::ifDescr'
        },
        'ifDescr2' => {
          'plugin' => 'interface2',
          'oids' => 'IF-MIB::ifDescr2'
        }
      }]
    }
  },
  data => {
    memAvailReal => {
      'plugin' => 'memory',
      'type' => 'memory',
      'oids' => '1.3.6.1.4.1.2021.4.6.0',
      'typeinstance' => 'free',
      'indexkey' => {
      'source' => 'PluginInstance'
      }
    }
  }
}
```
#### Class: `collectd::plugin::statsd`

```puppet
class { 'collectd::plugin::statsd':
  host            => '0.0.0.0',
  port            => 8125,
  deletecounters  => false,
  deletetimers    => false,
  deletegauges    => false,
  deletesets      => false,
  timerpercentile => ['50','90'],
}
```

#### Class: `collectd::plugin::swap`

```puppet
class { 'collectd::plugin::swap':
  reportbydevice => false,
  reportbytes    => true
}
```

#### Class: `collectd::plugin::syslog`

```puppet
class { 'collectd::plugin::syslog':
  log_level => 'warning'
}
```

#### Class: `collectd::plugin::target_v5upgrade`

```puppet
class { 'collectd::plugin::target_v5upgrade':
}
```

#### Class: `collectd::plugin::tcpconns`

```puppet
class { 'collectd::plugin::tcpconns':
  localports  => ['25', '12026'],
  remoteports => ['25'],
  listening   => false,
}
```

#### Class: `collectd::plugin::tail`

```puppet
collectd::plugin::tail::file { 'exim-log':
  filename => '/var/log/exim4/mainlog',
  instance => 'exim',
  matches  => [
    {
      regex    => 'S=([1-9][0-9]*)',
      dstype   => 'CounterAdd',
      type     => 'ipt_bytes',
      instance => 'total',
    },
    {
      regex    => '\\<R=local_user\\>',
      dstype   => 'CounterInc',
      type     => 'counter',
      instance => 'local_user',
    }
  ]
}
```

#### Class: `collectd::plugin::tail_csv`

```puppet
class { 'collectd::plugin::tail_csv':
  metrics => {
    'snort-dropped' => {
      'type'        => 'gauge',
      'values_from' => 1,
      'instance'    => "dropped"
    },
  },
  files  => {
    '/var/log/snort/snort.stats' => {
      'collect'   => ['snort-dropped'],
      'plugin'    => 'snortstats',
      'instance'  => 'eth0',
      'interval'  => 600,
      'time_from' => 5,
    }
  }
}
```

#### Class: `collectd::plugin::thermal`

```puppet
class { 'collectd::plugin::thermal':
  devices        => ['foo0'],
  ignoreselected => false,
}
```

#### Class: `collectd::plugin::threshold`

```puppet
class { 'collectd::plugin::threshold':
  hosts   => [
    {
      name    => 'example.com',
      plugins => [
        {
          name  => 'load',
          types => [
            {
              name        => 'load',
              data_source => 'shortterm',
              warning_max => $facts.dig('processors', 'count') * 1.2,
              failure_max => $facts.dig('processors', 'count') * 1.9,
            },
            {
              name        => 'load',
              data_source => 'midterm',
              warning_max => $facts.dig('processors', 'count') * 1.1,
              failure_max => $facts.dig('processors', 'count') * 1.7,
            },
            {
              name        => 'load',
              data_source => 'longterm',
              warning_max => $facts.dig('processors', 'count'),
              failure_max => $facts.dig('processors', 'count') * 1.5,
            },
          ],
        },
      ],
    },
  ],
  plugins => [
    # See plugin definition above
  ],
  types   => [
    # See types definition above
  ],
}
```

#### Class: `collectd::plugin::unixsock`

```puppet
class {'collectd::plugin::unixsock':
  socketfile   => '/var/run/collectd-sock',
  socketgroup  => 'nagios',
  socketperms  => '0770',
  deletesocket => false,
}
```

#### Class: `collectd::plugin::uptime`

```puppet
class {'collectd::plugin::uptime':
}
```

#### Class: `collectd::plugin::users`

```puppet
class {'collectd::plugin::users':
}
```

#### Class: `collectd::plugin::uuid`

```puppet
class {'collectd::plugin::uuid':
  uuid_file => '/etc/uuid',
}
```

#### Class: `collectd::plugin::varnish`

```puppet
class { 'collectd::plugin::varnish':
  instances => {
    'instanceName' => {
      'CollectCache' => 'true',
      'CollectBackend' => 'true',
      'CollectConnections' => 'true',
      'CollectSHM' => 'true',
      'CollectESI' => 'false',
      'CollectFetch' => 'true',
      'CollectHCB' => 'false',
      'CollectTotals' => 'true',
      'CollectWorkers' => 'true',
    }
  },
}
```

#### Class: `collectd::plugin::vmem`

```puppet
class { 'collectd::plugin::vmem':
  verbose => true,
}
```

#### Class: `collectd::plugin::write_graphite`

The `write_graphite` plugin writes data to Graphite, an open-source metrics
storage and graphing project.

```puppet
collectd::plugin::write_graphite::carbon {'my_graphite':
  graphitehost   => 'graphite.example.org',
  graphiteport   => 2003,
  graphiteprefix => '',
  protocol       => 'tcp'
}
```

You can define multiple Graphite backends where will be metrics send. Each
backend should have unique title:

```puppet
collectd::plugin::write_graphite::carbon {'secondary_graphite':
  graphitehost        => 'graphite.example.org',
  graphiteport        => 2004,
  graphiteprefix      => '',
  protocol            => 'udp',
  escapecharacter     => '_',
  alwaysappendds      => true,
  storerates          => true,
  separateinstances   => false,
  logsenderrors       => true
  preserveseparator   => false,
  dropduplicatefields => false,
}
```

The `preserveseparator` and `dropduplicatefields` fields are supported as of
collectd version >= 5.7.

#### Class: `collectd::plugin::write_http`

The write_http plugin supports two ways of configuration, the old plugin format using urls:

```puppet
class { 'collectd::plugin::write_http':
  urls => {
    'collect1.example.org' => { 'format' => 'JSON' },
    'collect2.example.org' => {},
  }
}
```

And the new plugin format using nodes:

```puppet
class { 'collectd::plugin::write_http':
  nodes => {
    'collect1' => { 'url' => 'collect1.example.org', 'format' => 'JSON' },
    'collect2' => { 'url' => 'collect2.example.org'},
  }
}
```

#### Class: `collectd::plugin::write_kafka`

* Requires the [Apache Kafka C/C++ library](https://github.com/edenhill/librdkafka)
* Available in collectd version >= 5.5.

```puppet
class { 'collectd::plugin::write_kafka':
  kafka_host => 'localhost',
  kafka_port => 9092,
  topics     => {
    'mytopic'      => { 'format' => 'JSON' },
  },
  properties => {
    'myproperty'   => { 'myvalue' },
  },
  meta       => {
    'mymeta'       => { 'myvalue' },
  }
}
```

#### Class: `collectd::plugin::write_log`

```puppet
class { 'collectd::plugin::write_log':
  format => 'JSON',
}
```

#### Class: `collectd::plugin::write_prometheus`

* The "host" option requires collectd 5.9 or later and will be ignored otherwise.

```puppet
class { 'collectd::plugin::write_prometheus':
  host => 'localhost',
  port => '9103',
}
```

**Note:** Requires collectd 5.7 or later.

#### Class: `collectd::plugin::write_network`

##### Deprecated

```puppet
class { 'collectd::plugin::write_network':
  servers => {
    'collect1.example.org' => { 'serverport' => '25826' },
    'collect2.example.org' => { 'serverport' => '25826' }
  }
}
```

#### Class: `collectd::plugin::write_riemann`

```puppet
class { 'collectd::plugin::write_riemann':
  nodes => [
    {
      'name' => 'riemann.example.org',
      'host' => 'riemann.example.org',
      'port' => 5555,
      'protocol' => 'TCP'
    }
  ],
  tags         => ['foo'],
  attributes   => {'bar' => 'baz'},
}
```

#### Class: `collectd::plugin::write_sensu`

```puppet
class { 'collectd::plugin::write_sensu':
  sensu_host => 'sensu.example.org',
  sensu_port => 3030,
}
```

#### Class: `collectd::plugin::write_tsdb`

```puppet
class { 'collectd::plugin::write_tsdb':
  host             => 'tsdb.example.org',
  port             => 4242,
  host_tags        => ['environment=production', 'colocation=AWS'],
  store_rates      => false,
  always_append_ds => false,
}
```

#### Class: `collectd::plugin::zfs_arc`

```puppet
class { 'collectd::plugin::zfs_arc':
}
```

#### Class: `collectd::plugin::zookeeper`

```puppet
class { 'collectd::plugin::zookeeper':
  zookeeper_host  => 'localhost',
  zookeeper_port  => '2181',
}
```

##### types.db

Collectd needs to know how to handle each collected datapoint.
For this it uses a database file called [`types.db`](https://collectd.org/documentation/manpages/types.db.5.shtml)

Those files can be created using the `collectd::typesdb` and `collectd::type`
define resources.

```puppet
$db = '/etc/collectd/types.db'
collectd::typesdb { $db: }

collectd::type { "response_size-${db}":
  target  => $db,
  ds_type => 'ABSOLUTE',
  min     => 0,
  max     => 10000000,
  ds_name => 'value',
}

class { 'collectd':
  typesdb      => [
    '/usr/share/collectd/types.db',
    $typesdb,
  ],
}
```

Other software may need to read the Collectd types database files. To allow
non-root users to read from a `collectd::typesdb` file like so:

```puppet
$db = '/etc/collectd/types.db'
collectd::typesdb { $db:
  mode => '0644',
}
```

## Puppet Tasks
Assuming that the collectdctl command is available on remote nodes puppet tasks exist to
run collectdctl and collect results from nodes. The tasks rely on `python3` being available
also.

### Puppet Task collectd::listval
```bash
$ bolt task show collectd::listval
collectd::listval - Lists all available collectd metrics

USAGE:
bolt task run --nodes <node-name> collectd::listval
collectd::listval - Lists all available collectd metrics

USAGE:
bolt task run --nodes <node-name> collectd::listval
```

### Puppet Task collectd::getval
```bash
$ bolt task show collectd::getval

collectd::getval - Get a particular metric for a host

USAGE:
bolt task run --nodes <node-name> collectd::getval metric=<value>

PARAMETERS:
- metric: String[1]
    Name of metric, e.g. load/load-relative

```

#### Example Task collectd::getval

```bash
$ bolt -u root task run collectd::getval metric=load/load-relative -n aiadm32.example.org
```

returns the values of the load metric.

```json
  {
    "metric": "load/load-relative",
    "values": {
      "shortterm": "1.750000e-01",
      "longterm": "8.000000e-02",
      "midterm": "8.500000e-02"
    }
  }
```

## Limitations

See metadata.json for supported platforms

## Known issues

### Puppet needs two runs to correctly write my conf, why?

Some plugins will need two runs of Puppet to fully generate the configuration
for collectd. See [this issue](https://github.com/pdxcat/puppet-module-collectd/issues/162).
This can be avoided by specifying a minimum version (`$minimum_version`) for
the collectd class. e.g. Setting this to 1.2.3 will make this module assume on
the first run (when the fact responsible to provide the collectd version is not
yet available) that your systems are running collectd 1.2.3 and generate the
configuration accordingly.

## Development

### Running tests

This project contains tests for [rspec-puppet](http://rspec-puppet.com/).

Quickstart:

```bash
gem install bundler
bundle install
bundle exec rake lint
bundle exec rake validate
bundle exec rake rubocop
bundle exec rake spec SPEC_OPTS='--format documentation'
```

### Version scoping

Some plugins or some options in plugins are only available for recent versions
of collectd.

This module shall not use unsupported configuration directives. Look at
[templates/loadplugin.conf.erb](https://github.com/voxpupuli/puppet-collectd/blob/master/templates/loadplugin.conf.erb)
for a hands-on example.

Please make use of the search by branch/tags on the collectd github to see when
a function has been first released.

Reading the [collectd.conf.pod](https://github.com/collectd/collectd/blob/master/src/collectd.conf.pod)
file is good, validating the presence of the code in the .c files is even better.

### Authors

Puppet-collectd is maintained by VoxPupuli. Before moving to VoxPupuli it was
written and maintained by [TheCAT](https://www.cat.pdx.edu/) in the
[pdxcat](https://github.com/pdxcat/) github org.
