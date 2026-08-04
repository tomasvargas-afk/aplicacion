import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String userId);

  Future<Either<Failure, Profile>> updateProfile(Profile profile);

  Future<Either<Failure, String>> uploadAvatar(String userId, File file);
}
