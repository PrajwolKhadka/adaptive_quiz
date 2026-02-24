// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileApiModel _$ProfileApiModelFromJson(Map<String, dynamic> json) =>
    ProfileApiModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      className: (json['className'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      isFirstLogin: json['isFirstLogin'] as bool,
    );

Map<String, dynamic> _$ProfileApiModelToJson(ProfileApiModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'className': instance.className,
      'imageUrl': instance.imageUrl,
      'isFirstLogin': instance.isFirstLogin,
    };
