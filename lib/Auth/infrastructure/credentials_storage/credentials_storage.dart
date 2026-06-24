import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:innox/auth/infrastructure/credentials_storage/secured_credentials_storage.dart';

class CredentialsStorage implements SecuredCredentialsStorage {
  final FlutterSecureStorage _storage;
  final String _key = dotenv.env["CREDENTIAL_KEY"] ?? "";
  final String _profileKey = dotenv.env["PROFILE_KEY"] ?? "";
  String? _cachedCredentials;

  CredentialsStorage({required FlutterSecureStorage storage})
      : _storage = storage;

  Future<void> saveProfile(String profileJson) async {
    try {
      await _storage.write(key: _profileKey, value: profileJson);
      debugPrint('✅ Profile saved');
    } catch (e) {
      debugPrint('❌ Failed to save profile: $e');
    }
  }

  Future<String?> readProfile() async {
    try{
      return await _storage.read(key: _profileKey);
    } catch (e) {
      debugPrint('❌ Failed to read profile: $e');
      return null;
    }
  }

  @override
  Future<String?> read() async {
    if (_cachedCredentials != null) {
      debugPrint('✅ Returning cached credentials');
      return _cachedCredentials;
    }
    try {
      final json = await _storage.read(key: _key);
      debugPrint('✅ Token from storage: ${json != null ? "exists" : "null"}');
      if (json == null) {
        return null;
      }
      return _cachedCredentials = json;
    } catch(e) {
      debugPrint("Failed to read credentials: $e");
      _cachedCredentials = null;
      return null;
    }
  }

  @override
  Future<void> save(String credentials) async {
    try {
      _cachedCredentials = credentials;
      await _storage.write(key: _key, value: credentials);
      debugPrint('✅ Credentials saved');
    } catch (e) {
      debugPrint("Failed to save credentials: $e");
      _cachedCredentials = null;
      rethrow;
    }
  }

  @override
  Future<void> clear() async{
    _cachedCredentials = null;
    try {
      await _storage.delete(key: _key);
      debugPrint('✅ Credentials cleared');
    } catch (e) {
      await _storage.deleteAll();
      debugPrint('❌ Failed to clear credentials: $e');
    }
  }
}
