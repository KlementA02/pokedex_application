import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_application/core/dio_api.dart';

class AuthRemoteService {
  final DioApi dioApi;
  AuthRemoteService(this.dioApi);

  Future<void> loginUser(String username, String password) async {
    final String endpoint =
        'https://imprudently-isotactic-neymar.ngrok-free.dev/pokedex/api/login';

    try {
      final response = await dioApi.post(
        endpoint,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        // Handle successful login
        final Map<String, dynamic> responseData = response.data;
        String token = responseData['token'];
        Map<String, dynamic> userData = responseData['user'];
        debugPrint('Login successful');
        debugPrint('Token: $token');
        debugPrint('User Data: $userData');
      } else {
        // Handle unsuccessful login
        debugPrint('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      debugPrint('Error during login: $e');
    }
  }

  Future<void> signUpUser(
    String username,
    String email,
    String password,
  ) async {
    final String endpoint =
        'https://imprudently-isotactic-neymar.ngrok-free.dev/pokedex/api/sign';

    try {
      final response = await dioApi.post(
        endpoint,
        data: {'username': username, 'email': email, 'password': password},
      );

      // Django returned 200 OK and created the token
      final Map<String, dynamic> data = response.data;
      String token = data['token'];

      debugPrint('Signup Successful! Auto-logged in.');
      debugPrint('Token: $token');
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        // Django returned serializer.errors (e.g., {"username": ["A user with that username already exists."]})
        Map<String, dynamic> validationErrors = e.response?.data;

        debugPrint('Signup Validation Failed:');
        validationErrors.forEach((field, errors) {
          debugPrint('$field: ${errors.join(', ')}');
        });
      } else {
        debugPrint('Something went wrong: ${e.message}');
      }
    }
  }
}
