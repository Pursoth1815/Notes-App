// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String?,
      title: fields[1] as String,
      createdAt: fields[3] as DateTime,
      status: fields[2] as CategoryStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryStatusAdapter extends TypeAdapter<CategoryStatus> {
  @override
  final int typeId = 0;

  @override
  CategoryStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CategoryStatus.selected;
      case 1:
        return CategoryStatus.notSelected;
      default:
        return CategoryStatus.selected;
    }
  }

  @override
  void write(BinaryWriter writer, CategoryStatus obj) {
    switch (obj) {
      case CategoryStatus.selected:
        writer.writeByte(0);
        break;
      case CategoryStatus.notSelected:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
