import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';
import 'package:adaptive_quiz/features/auth/domain/entities/auth_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String fullName;
  final String email;
  final String className;
  final String role;
  final bool isFirstLogin;
  final String? token;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.className,
    required this.role,
    required this.isFirstLogin,
    this.token,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);
}

extension AuthApiModelX on AuthApiModel {
  // Convert API model to domain entity
  AuthResponse toEntity() {
    return AuthResponse(
      token: token ?? '',
      isFirstLogin: isFirstLogin,
      studentId: id ?? '',
      fullName: fullName,
      email: email,
      className: className,
    );
  }

  // Convert API model to Hive model for local storage
  AuthHiveModel toHiveModel() {
    return AuthHiveModel(
      studentId: id,
      fullName: fullName,
      email: email,
      className: className,
      token: token,
    );
  }
}
