import 'package:dio/dio.dart';
import 'package:pokedex_application/auth/domain/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final ITokenStorage _tokenStorage;
  final Function() _onUnauthenticated; // Callback to trigger a logout state in your UI/Bloc

  AuthInterceptor({
    required ITokenStorage tokenStorage,
    required Function() onUnauthenticated,
  })  : _tokenStorage = tokenStorage,
        _onUnauthenticated = onUnauthenticated;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Fetch the token from your domain storage abstraction
    final token = await _tokenStorage.getToken();

    // 2. If a token exists, attach it to the authorization header
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Explicitly accept JSON responses
    options.headers['Accept'] = 'application/json';

    // Continue the request pipeline
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 3. Catch unauthorized errors from the server (e.g., token expired or revoked)
    if (err.response?.statusCode == 401) {
      // Clear local storage
      _tokenStorage.clearToken();
      
      // Notify the app state management that the user is no longer unauthenticated
      _onUnauthenticated();
    }

    // Continue the error pipeline so your repositories can convert this to an AuthFailure
    return handler.next(err);
  }
}