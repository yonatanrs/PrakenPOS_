// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartAdapter extends TypeAdapter<Cart> {
  @override
  Cart read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cart(
      idProduct: fields[0] as String,
      nameProduct: fields[1] as String,
      unit: fields[2] as String,
      stock: fields[3] as int,
      qty: fields[4] as int,
      subTotal: fields[5] as int,
      discount: fields[6] as int,
      total: fields[7] as int,
      price: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Cart obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.idProduct)
      ..writeByte(1)
      ..write(obj.nameProduct)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.stock)
      ..writeByte(4)
      ..write(obj.qty)
      ..writeByte(5)
      ..write(obj.subTotal)
      ..writeByte(6)
      ..write(obj.discount)
      ..writeByte(7)
      ..write(obj.total)
      ..writeByte(8)
      ..write(obj.price);
  }

  @override
  int get typeId => 3;
}
