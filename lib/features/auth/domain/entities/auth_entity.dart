import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id;
  final String fullName;
  final String email;
  final dynamic className;
  final bool isFirstLogin;
  final String? token;

  const AuthEntity({
    this.id,
    required this.fullName,
    required this.email,
    required this.className,
    required this.isFirstLogin,
    this.token,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    className,
    isFirstLogin,
    token,
  ];
}
