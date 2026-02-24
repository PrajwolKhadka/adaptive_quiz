import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String fullName;
  final String email;
  final int className;
  final String? imageUrl;
  final bool isFirstLogin;

  const ProfileEntity({
    required this.fullName,
    required this.email,
    required this.className,
    this.imageUrl,
    required this.isFirstLogin,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    className,
    imageUrl,
    isFirstLogin,
  ];
}