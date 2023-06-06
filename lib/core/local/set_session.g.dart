// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetSessAdapter extends TypeAdapter<SetSess> {
  @override
  final int typeId = 1;

  @override
  SetSess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetSess(
      clientCode: fields[0] as String?,
      koiskIdCode: fields[3] as String?,
      serviceCentreCode: fields[1] as int?,
      serviceCentreName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SetSess obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.clientCode)
      ..writeByte(1)
      ..write(obj.serviceCentreCode)
      ..writeByte(2)
      ..write(obj.serviceCentreName)
      ..writeByte(3)
      ..write(obj.koiskIdCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetSessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
