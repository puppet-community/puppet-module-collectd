# @summary represents a modbus host entry
type Collectd::Modbus::Host = Struct[{
    NotUndef['address'] => String[1],
    NotUndef['port'] => Stdlib::Port,
    NotUndef['slaves'] => Hash[Integer, Collectd::Modbus::Slave],
    Optional['interval'] => Integer[0]
}]
