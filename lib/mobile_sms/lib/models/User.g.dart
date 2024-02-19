// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  int get typeId => 0;

  @override
  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int? ?? 0, // Default value of 0 if null
      username: fields[1] as String? ?? '', // Default value of empty string if null
      password: fields[2] as String? ?? '', // Default value of empty string if null
      fullname: fields[3] as String? ?? '', // Default value of empty string if null
      level: fields[4] as String? ?? '', // Default value of empty string if null
      roles: fields[5] as String? ?? '', // Default value of empty string if null
      approvalRoles: fields[6] as String? ?? '', // Default value of empty string if null
      brand: fields[7] as String? ?? '', // Default value of empty string if null
      custSegment: fields[8] as String? ?? '', // Default value of empty string if null
      businessUnit: fields[9] as String? ?? '', // Default value of empty string if null
      token: fields[10] as String? ?? '', // Default value of empty string if null
      message: fields[11] as String? ?? '', // Default value of empty string if null
      code: fields[12] as int? ?? 0, // Default value of 0 if null
      user: fields[13] as User?, // Nullable, no default needed
    );
  }


  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.fullname)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.roles)
      ..writeByte(6)
      ..write(obj.approvalRoles)
      ..writeByte(7)
      ..write(obj.brand)
      ..writeByte(8)
      ..write(obj.custSegment)
      ..writeByte(9)
      ..write(obj.businessUnit)
      ..writeByte(10)
      ..write(obj.token)
      ..writeByte(11)
      ..write(obj.message)
      ..writeByte(12)
      ..write(obj.code)
      ..writeByte(13)
      ..write(obj.user);
  }
}
