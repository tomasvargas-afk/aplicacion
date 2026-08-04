import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider));
});

/// Drives `go_router`'s redirect: null = signed out, [AppUser] = signed in.
final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateChangesProvider).valueOrNull;
});

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password);
    return result.match(
      (failure) {
        state = AsyncData(null);
        return failure.displayMessage;
      },
      (_) {
        state = const AsyncData(null);
        return null;
      },
    );
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signUp(
          email: email,
          password: password,
          fullName: fullName,
        );
    return result.match(
      (failure) {
        state = AsyncData(null);
        return failure.displayMessage;
      },
      (_) {
        state = const AsyncData(null);
        return null;
      },
    );
  }

  Future<String?> resetPassword(String email) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).resetPassword(email);
    state = const AsyncData(null);
    return result.match((failure) => failure.displayMessage, (_) => null);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
