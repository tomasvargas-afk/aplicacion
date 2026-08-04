import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/profile.dart';

class ProfileRemoteDatasource {
  ProfileRemoteDatasource(this._client, this._storage);

  final SupabaseClient _client;
  final StorageService _storage;

  Future<Profile> getProfile(String userId) async {
    try {
      final row = await _client
          .from(SupabaseTables.profiles)
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (row == null) {
        // Self-heal: accounts created before the on-signup trigger existed
        // (or if it ever fails) won't have a profiles row yet.
        final created = await _client
            .from(SupabaseTables.profiles)
            .insert({'id': userId})
            .select()
            .single();
        return Profile.fromJson(created);
      }
      return Profile.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Profile> updateProfile(Profile profile) async {
    try {
      final payload = profile.toJson()..remove('id');
      final row = await _client
          .from(SupabaseTables.profiles)
          .update(payload)
          .eq('id', profile.id)
          .select()
          .single();
      return Profile.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<String> uploadAvatar(String userId, File file) async {
    try {
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      return await _storage.uploadImage(
        bucket: SupabaseBuckets.avatars,
        userId: userId,
        file: file,
        fileName: fileName,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
