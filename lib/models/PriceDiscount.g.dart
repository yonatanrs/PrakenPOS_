// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PriceDiscount.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceDiscountAdapter extends TypeAdapter<PriceDiscount> {
  @override
  PriceDiscount read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceDiscount(
      id: fields[0] as int,
      idCustomer: fields[1] as String,
      customer: fields[2] as String,
      idProduct: fields[3] as String,
      product: fields[4] as String,
      unit: fields[5] as String,
      group: fields[6] as String,
      businessUnit: fields[7] as String,
      price: fields[8] as String,
      disc1: fields[9] as int,
      disc2: fields[10] as int,
    )
      ..fromDate = fields[11] as String
      ..endDate = fields[12] as String;
  }

  @override
  void write(BinaryWriter writer, PriceDiscount obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idCustomer)
      ..writeByte(2)
      ..write(obj.customer)
      ..writeByte(3)
      ..write(obj.idProduct)
      ..writeByte(4)
      ..write(obj.product)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.group)
      ..writeByte(7)
      ..write(obj.businessUnit)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.disc1)
      ..writeByte(10)
      ..write(obj.disc2)
      ..writeByte(11)
      ..write(obj.fromDate)
      ..writeByte(12)
      ..write(obj.endDate);
  }

  @override
  int get typeId => 2;
}
