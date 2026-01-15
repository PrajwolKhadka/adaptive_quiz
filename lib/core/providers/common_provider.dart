// core/common/provider/common_provider.dart
import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/services/hive/hive_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.read(dioProvider);
  return ApiClient(dio);
});

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());