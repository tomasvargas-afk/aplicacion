import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  AppUser? get currentUser;

  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> resetPassword(String email);
}
