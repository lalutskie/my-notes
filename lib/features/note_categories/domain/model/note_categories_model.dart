import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'note_categories_model.g.dart';

@HiveType(typeId: 3)
class NoteCategoriesModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String uid;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final DateTime? createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  @HiveField(5)
  final DateTime? deletedAt;

  @HiveField(6)
  final bool isDeleted ;

  NoteCategoriesModel({
    required this.id,
    required this.uid,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted = false,
  });

  factory NoteCategoriesModel.fromMap(Map<String, dynamic> map) {
    return NoteCategoriesModel(
      id: map['id'] ?? '', 
      uid: map['uid'] ?? '', 
      name: map['name'] ?? '',
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
      deletedAt: _toDate(map['deletedAt']),
      isDeleted: map['isDeleted'] as bool
    );
  }

  

  NoteCategoriesModel copyWith(
    {String? id,
    String? uid,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return NoteCategoriesModel(
      id: id ?? this.id, 
      uid: uid ?? this.uid, 
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isDeleted': isDeleted,
    };
  }

}

DateTime? _toDate(dynamic value) {
  if(value == null) return null;
  if(value is Timestamp) return value.toDate();
  if(value is DateTime) return value;
  return null;
}