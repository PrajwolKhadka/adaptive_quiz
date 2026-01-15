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