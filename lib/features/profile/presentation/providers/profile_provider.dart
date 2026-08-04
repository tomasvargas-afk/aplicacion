import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/services/storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((ref) {
  return ProfileRemoteDatasource(
    ref.watch(supabaseClientProvider),
    ref.watch(storageServiceProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDatasourceProvider));
});

final profileProvider = FutureProvider.autoDispose<Profile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final result = await ref.watch(profileRepositoryProvider).getProfile(user.id);
  return result.match((failure) => throw failure, (profile) => profile);
});

class ProfileController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> updateProfile(Profile profile) async {
    state = const AsyncLoading();
    final result = await ref.read(profileRepositoryProvider).updateProfile(profile);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(profileProvider);
        return null;
      },
    );
  }

  Future<String?> updateAvatar(String userId, File file) async {
    state = const AsyncLoading();
    final uploadResult = await ref.read(profileRepositoryProvider).uploadAvatar(userId, file);
    final error = await uploadResult.match(
      (failure) async => failure.displayMessage,
      (url) async {
        final current = ref.read(profileProvider).valueOrNull;
        if (current == null) return 'No se pudo cargar el perfil';
        final updateResult = await ref
            .read(profileRepositoryProvider)
            .updateProfile(current.copyWith(avatarUrl: url));
        return updateResult.match((failure) => failure.displayMessage, (_) => null);
      },
    );
    state = const AsyncData(null);
    if (error == null) ref.invalidate(profileProvider);
    return error;
  }
}

final profileControllerProvider = AsyncNotifierProvider<ProfileController, void>(
  ProfileController.new,
);
