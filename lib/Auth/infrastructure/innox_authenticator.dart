import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:innox/auth/domain/user.dart';
import 'package:innox/auth/infrastructure/user_dto.dart';
import 'package:innox/auth/infrastructure/user_store.dart';
import 'package:innox/core/infrastructure/dio_api.dart';
import 'package:innox/auth/domain/auth_failure.dart';
import 'package:innox/auth/infrastructure/credentials_storage/credentials_storage.dart';
import 'package:innox/core/infrastructure/dio_extension.dart';

class IAuthenticator {
  final CredentialsStorage _credentialsStorage;
  static String? token;
  final DioAPI _api;
  final UserStore _userCache;
  bool _launchCheckDone = false;

  IAuthenticator(
      {required CredentialsStorage credentialsStorage,
      required DioAPI api,
      required UserStore userCache})
      : _credentialsStorage = credentialsStorage,
        _api = api,
        _userCache = userCache;

  Future<String?> getSignedInCredentials() async {
    return await _credentialsStorage.read();
  }

  Future<User?> getSignedInUser() async {
    try {
      final user = await _userCache.getAllUsers();
      if (user.isNotEmpty) {
        return user.last.toDomain();
      }
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get signed in user: $e');
      return null;
    }
  }

  Future<bool> isSignedIn() async {
    try {
      if (!_launchCheckDone) {
        _launchCheckDone = true;
        await _credentialsStorage.clear();
        await _userCache.deleteAllUsers();
        debugPrint("App launched - session cleared, redirecting to login");
        return false;
      }
      final credentials = await _credentialsStorage.read();
      debugPrint('🔑 Token exists: ${credentials != null}');
      if (credentials == null) return false;

      token = credentials;

      final user = await getSignedInUser();
      debugPrint('👤 User in cache: ${user != null}');

      if (user != null) return true;

      debugPrint('⚠️ User cache empty, attempting recovery from profile...');
      final profileJson = await _credentialsStorage.readProfile();

      if (profileJson != null) {
        try {
          final dto = UserDTO.fromJson(jsonDecode(profileJson));
          await _userCache.saveUser(dto, dto.usaIDpk);
          debugPrint('✅ User recovered from profile storage');
          return true;
        } catch (e) {
          debugPrint('❌ Failed to recover user from profile: $e');
        }
      }

      debugPrint('❌ Session unrecoverable, clearing token');
      await _credentialsStorage.clear();
      return false;
    } catch (e) {
      debugPrint('❌ isSignedIn threw unexpectedly: $e');
      return false;
    }
  }


  Future<Either<AuthFailure, Unit>> login(
      String userName, String password, String server) async {
    try {
      final response = await _api.post(
        '/Accounts/Login',
        data: {
          "username": userName,
          "password": password,
          "server": "production",
        },
      );

      if (response.statusCode == 200) {
        final tokenValue = response.data['token'] as String;
        final userModel = response.data['userModel'];

        await _credentialsStorage.save(tokenValue);
        await _credentialsStorage.saveProfile(jsonEncode(userModel));
        final dto = UserDTO.fromJson(userModel);
        await _userCache.saveUser(dto, dto.usaIDpk);

        token = tokenValue;
        debugPrint('✅ Login successful, all data persisted');
        return right(unit);
      } else {
        return left(const AuthFailure.server("Internal Server Error"));
      }
    } on DioException catch (e) {
      if (e.isConnectionError) {
        return left(const AuthFailure.server("No Internet Connection"));
      } else if (e.response?.statusCode == 400) {
        return left(AuthFailure.inValidCredentials(e.response?.data['Detail']));
      }
      return left(const AuthFailure.server("Internal Server Error!"));
    } catch (e) {
      debugPrint('❌ Login error: $e');
      return left(const AuthFailure.storage());
    }
  }



  Future<Map<String, dynamic>?> getFullProfileFromStorage() async {
    final jsonString = await _credentialsStorage.readProfile();
    debugPrint('📋 Raw profile json from storage: $jsonString');

    if(jsonString != null){
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    debugPrint('📋 Profile is null in storage');
    return null;
  }

  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await _credentialsStorage.clear();
      await _userCache.deleteAllUsers();
      return right(unit);
    } on PlatformException {
      return const Left(AuthFailure.storage());
    }
  }
}
