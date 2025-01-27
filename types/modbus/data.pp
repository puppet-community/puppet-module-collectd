# @summary represents a modbus data entry
#
# https://github.com/collectd/collectd/blob/main/src/modbus.c
type Collectd::Modbus::Data = Struct[{
    Optional['instance']      => String,
    NotUndef['type']          => String[1],
    NotUndef['register_base'] => Integer[0],
    NotUndef['register_type'] => Enum[
      'Int16',
      'Int32',
      'Int32LE',
      'Uint16',
      'Uint32',
      'Uint32LE',
      'Float',
      'FloatLE',
      'Uint64',
      'Int64',
      'Double',
    ],
    Optional['register_cmd']  => Enum['ReadHolding', 'ReadInput'],
}]
