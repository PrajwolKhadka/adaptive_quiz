// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceApiModel _$ResourceApiModelFromJson(Map<String, dynamic> json) =>
    ResourceApiModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      format: json['format'] as String,
      fileUrl: json['fileUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
    );

Map<String, dynamic> _$ResourceApiModelToJson(ResourceApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'format': instance.format,
      'fileUrl': instance.fileUrl,
      'linkUrl': instance.linkUrl,
    };
