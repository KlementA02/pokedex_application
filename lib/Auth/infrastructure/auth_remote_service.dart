import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pokedex_application/auth/infrastructure/user_dto.dart';
import 'package:pokedex_application/core/dio_api.dart';

class AuthRemoteService {
  final DioApi dioApi;

  AuthRemoteService(this.dioApi);

  Future<({String token, UserDto user})> loginUser(
    String username,
    String password,
  ) async {
    try {
      final response = await dioApi.post(
        '/pokedex/api/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        dioApi.setAuthToken(token);

        final user = UserDto.fromJson(userData);
        debugPrint('Login successful');
        return (token: token, user: user);
      } else {
        throw Exception(
          'Login failed with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ Login error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error during login: $e');
      rethrow;
    }
  }

  Future<({String token, UserDto user})> registerUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await dioApi.post(
        '/pokedex/api/signup',
        data: {'username': username, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        dioApi.setAuthToken(token);

        final user = UserDto.fromJson(userData);
        debugPrint('Registration successful');
        return (token: token, user: user);
      } else {
        throw Exception(
          'Registration failed with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ Registration error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Error during registration: $e');
      rethrow;
    }
  }
}
