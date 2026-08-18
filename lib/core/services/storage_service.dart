import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/supabase_client_provider.dart';

/// Uploads user images (avatar, recipe photo) to Supabase Storage under a
/// `<userId>/...` path so the owner-only RLS storage policies apply.
class StorageService {
  StorageService(this._client);

  final SupabaseClient _client;

  Future<String> uploadImage({
    required String bucket,
    required String userId,
    required File file,
    required String fileName,
  }) async {
    final path = '$userId/$fileName';
    await _client.storage.from(bucket).upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  Future<void> deleteImage({required String bucket, required String path}) {
    return _client.storage.from(bucket).remove([path]);
  }

  /// Uploads to a private bucket and returns the storage *path* (not a
  /// public URL) — use [getSignedUrl] to display it.
  Future<String> uploadPrivateImage({
    required String bucket,
    required String userId,
    required File file,
    required String fileName,
  }) async {
    final path = '$userId/$fileName';
    await _client.storage.from(bucket).upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return path;
  }

  Future<String> getSignedUrl({
    required String bucket,
    required String path,
    int expiresInSeconds = 3600,
  }) {
    return _client.storage.from(bucket).createSignedUrl(path, expiresInSeconds);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(supabaseClientProvider));
});
