import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

part 'user_model.g.dart'; // run build_runner after this

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final DateTime? createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'],
      name: map['name'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'],
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'],
    );
  }

  UserModel copyWith({
  String? uid,
  String? email,
  String? name,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return UserModel(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
