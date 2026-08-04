import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDatasource _remote;

  AppUser _toEntity(dynamic user) => AppUser(id: user.id, email: user.email ?? '');

  @override
  Stream<AppUser?> get authStateChanges =>
      _remote.authStateChanges.map((u) => u == null ? null : _toEntity(u));

  @override
  AppUser? get currentUser {
    final user = _remote.currentUser;
    return user == null ? null : _toEntity(user);
  }

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.signIn(email: email, password: password);
      return Right(_toEntity(user));
    } on AuthException catch (e) {
      return Left(Failure.auth(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final user = await _remote.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      return Right(_toEntity(user));
    } on AuthException catch (e) {
      return Left(Failure.auth(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remote.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await _remote.resetPassword(email);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(Failure.auth(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
