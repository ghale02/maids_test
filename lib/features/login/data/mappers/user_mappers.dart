import 'package:maids_test/features/login/data/models/user_model.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';

extension UserModelToEntityMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        image: image,
        token: token,
      );
}
