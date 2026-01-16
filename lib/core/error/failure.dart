import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

// For API/Server related errors
class ApiFailure extends Failure {
  const ApiFailure({
    required super.message,
    super.statusCode,
  });
}

// For Local Database (Hive) related errors
class LocalFailure extends Failure {
  const LocalFailure({
    required super.message,
  });
}

// For Network connectivity issues
class SharedPrefsFailure extends Failure {
  const SharedPrefsFailure({
    required super.message,
  });
}