import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_api_model.g.dart';

@JsonSerializable()
class ProfileApiModel {
  final String fullName;
  final String email;
  final int className;
  final String? imageUrl;
  final bool isFirstLogin;

  ProfileApiModel({
    required this.fullName,
    required this.email,
    required this.className,
    this.imageUrl,
    required this.isFirstLogin,
  });

  factory ProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileApiModelToJson(this);

  ProfileEntity toEntity() {
    return ProfileEntity(
      fullName: fullName,
      email: email,
      className: className,
      imageUrl: imageUrl,
      isFirstLogin: isFirstLogin,
    );
  }
}