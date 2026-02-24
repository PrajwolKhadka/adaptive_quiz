import 'package:equatable/equatable.dart';

enum ResourceType { book, resource }
enum ResourceFormat { pdf, link }

class ResourceEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final ResourceType type;
  final ResourceFormat format;
  final String? fileUrl;
  final String? linkUrl;

  const ResourceEntity({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.format,
    this.fileUrl,
    this.linkUrl,
  });

  @override
  List<Object?> get props =>
      [id, title, description, type, format, fileUrl, linkUrl];
}