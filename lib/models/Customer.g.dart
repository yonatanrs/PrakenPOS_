// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Customer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  Customer read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      idCustomer: fields[0] as String,
      codeCust: fields[1] as String,
      nameCust: fields[2] as String,
      address: fields[3] as String,
      contact: fields[4] as String,
      segment: fields[5] as String,
      city: fields[6] as String,
      contactPerson: fields[7] as String,
      group: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.idCustomer)
      ..writeByte(1)
      ..write(obj.codeCust)
      ..writeByte(2)
      ..write(obj.nameCust)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.contact)
      ..writeByte(5)
      ..write(obj.segment)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.contactPerson)
      ..writeByte(8)
      ..write(obj.group);
  }

  @override
  int get typeId => 1;
}
