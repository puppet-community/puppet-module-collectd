# @summary Represents a modbus host's slave entry
type Collectd::Modbus::Slave = Struct[{
    NotUndef['instance'] => String[1],
    NotUndef['collect'] => Variant[
      String[1],
      Array[String[1], 1]
    ]
}]
