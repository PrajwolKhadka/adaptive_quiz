import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constant.dart';
import '../../domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  AuthHiveModel({
    required this.userId,
    required this.email,
    required this.password,
  });

  AuthEntity toEntity() => AuthEntity(
    userId: userId,
    email: email,
    password: password,
  );
}
