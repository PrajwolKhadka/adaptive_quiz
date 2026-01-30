import 'package:adaptive_quiz/features/auth/domain/entities/auth_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 0)
class AuthHiveModel extends Equatable {
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
    String? fullName,
    String? email,
    String? className,
    this.token,
  }) : fullName = fullName ?? '',
       email = email ?? '',
       className = className ?? '';

  // factory AuthHiveModel.fromEntity(AuthEntity entity) {
  //   return AuthHiveModel(
  //     studentId: entity.id,
  //     fullName: entity.fullName,
  //     email: entity.email,
  //     className: entity.className,
  //     token: entity.token,
  //   );
  // }

  // AuthEntity toEntity() {
  //   return AuthEntity(
  //     id: studentId,
  //     fullName: fullName,
  //     email: email,
  //     className: className,
  //     isFirstLogin: false,
  //     token: token,
  //   );
  // }

  @override
  List<Object?> get props => [studentId, fullName, email, className, token];
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      studentId: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      className: entity.className,
      token: entity.token,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      id: studentId,
      fullName: fullName,
      email: email,
      className: className,
      isFirstLogin: false,
      token: token,
    );
  }
}
