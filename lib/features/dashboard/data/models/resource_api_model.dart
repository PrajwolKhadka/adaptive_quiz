import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/resource_entity.dart';

part 'resource_api_model.g.dart';

@JsonSerializable()
class ResourceApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String? description;
  final String type;
  final String format;
  final String? fileUrl;
  final String? linkUrl;

  ResourceApiModel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.format,
    this.fileUrl,
    this.linkUrl,
  });

  factory ResourceApiModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceApiModelToJson(this);

  ResourceEntity toEntity() {
    return ResourceEntity(
      id: id,
      title: title,
      description: description,
      type: type.toUpperCase() == 'BOOK'
          ? ResourceType.book
          : ResourceType.resource,
      format: format.toUpperCase() == 'PDF'
          ? ResourceFormat.pdf
          : ResourceFormat.link,
      fileUrl: fileUrl,
      linkUrl: linkUrl,
    );
  }
}