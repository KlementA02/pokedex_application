import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pokedex_application/auth/domain/token_storage.dart';

class SecureTokenStorage implements ITokenStorage {
  final FlutterSecureStorage _storage;

  // A unique key used to look up the token in encrypted memory
  static const _tokenKey = 'auth_token_jwt';

  /// Pass an instance of FlutterSecureStorage, allowing you to mock it during tests.
  const SecureTokenStorage(this._storage);

  @override
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      // In production, handle or log secure storage access issues
      debugPrint('Error: $e');
      return null;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
