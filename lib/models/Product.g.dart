// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  Product read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      idProduct: fields[0] as String,
      nameProduct: fields[1] as String,
      unit: fields[2] as String,
      stock: fields[3] as int,
      subTotal: fields[4] as int,
      price: fields[5] as int,
      totalQty: fields[6] as int,
      group: fields[7] as String,
      category: fields[8] as String,
      brand: fields[9] as String,
      itemGroup: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.idProduct)
      ..writeByte(1)
      ..write(obj.nameProduct)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.stock)
      ..writeByte(4)
      ..write(obj.subTotal)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.totalQty)
      ..writeByte(7)
      ..write(obj.group)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.brand)
      ..writeByte(10)
      ..write(obj.itemGroup);
  }

  @override
  int get typeId => 0;
}
