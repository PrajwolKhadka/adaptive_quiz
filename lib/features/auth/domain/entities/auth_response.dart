// class AuthResponse {
//   final String token;
//   final bool isFirstLogin;
//
//   AuthResponse({
//     required this.token,
//     required this.isFirstLogin,
//   });
// }
import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String studentId;
  final String fullName;
  final String email;
  final String className;
  final bool isFirstLogin;
  final String token;

  AuthResponse({
    required this.studentId,
    required this.fullName,
    required this.email,
    required this.className,
    required this.isFirstLogin,
    required this.token,
  });

  // factory AuthResponse.fromJson(Map<String, dynamic> json) {
  //   return AuthResponse(
  //     studentId: json['studentId'],
  //     fullName: json['fullName'],
  //     email: json['email'],
  //     className: json['className'],
  //     isFirstLogin: json['isFirstLogin'],
  //     token: json['token'],
  //   );
  // }

  @override
  List<Object?> get props => [
    studentId,
    fullName,
    email,
    className,
    isFirstLogin,
    token,
  ];

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      studentId: json['studentId'],
      fullName: json['fullName'],
      email: json['email'],
      className: json['className'],
      isFirstLogin: json['isFirstLogin'],
      token: json['token'],
    );
  }
}
