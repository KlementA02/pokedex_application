import 'package:pokedex_application/core/dio_api.dart';

class AuthRemoteService {
  final DioApi dioApi;
  AuthRemoteService(this.dioApi);

  Future<void> loginUser(String username, String password) async {
    final String endpoint = 'pokedex/api/login';

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
        print('Login successful');
      } else {
        // Handle unsuccessful login
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error during login: $e');
    }
  }
}
