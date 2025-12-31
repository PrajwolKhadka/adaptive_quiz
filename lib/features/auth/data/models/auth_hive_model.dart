import 'package:hive/hive.dart';
import '../../domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 0)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  AuthHiveModel({
    required this.userId,
    required this.email,
    required this.password,
  });

  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      email: email,
      password: password,
    );
  }
}
