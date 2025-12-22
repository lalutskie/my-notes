import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 1)
class NotesModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String uid;
  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final DateTime? createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  @HiveField(6)
  final DateTime? deletedAt;

  @HiveField(7)
  final bool? isBookmarked;

  @HiveField(8)
  final String? categoryId;

  NotesModel({
    required this.id,
    required this.uid,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isBookmarked = false,
    this.categoryId,
  });

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'],
      description: map['description'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'],
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'],
      deletedAt: map['deletedAt'] is Timestamp
          ? (map['deletedAt'] as Timestamp).toDate()
          : map['deletedAt'],
      isBookmarked: map['isBookmarked'] as bool,
      categoryId: map['categoryId'],
      
    );
  }

  NotesModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isBookmarked,
    String? categoryId,
  }) {
    return NotesModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isBookmarked': isBookmarked,
      'categoryId': categoryId,
    };
  }
}
