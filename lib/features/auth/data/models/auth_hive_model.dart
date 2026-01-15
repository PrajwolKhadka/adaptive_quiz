import 'package:adaptive_quiz/features/auth/domain/entities/auth_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 0) // Ensure typeId 0 is unique in your app
class AuthHiveModel {
  @HiveField(0)
  final String? studentId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String className;

  @HiveField(4)
  final String? token;

  AuthHiveModel({
    this.studentId,
    required this.fullName,
    required this.email,
    required this.className,
    this.token,
  });

  // Initial constructor from Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      studentId: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      className: entity.className,
      token: entity.token,
    );
  }

  // Convert Hive Model back to Entity for the Domain Layer
  AuthEntity toEntity() {
    return AuthEntity(
      id: studentId,
      fullName: fullName,
      email: email,
      className: className,
      isFirstLogin: false, // If it's in Hive, they've already moved past first login
      token: token,
    );
  }
}