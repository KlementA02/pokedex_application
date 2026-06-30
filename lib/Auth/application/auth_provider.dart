import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pokedex_application/auth/domain/auth_failure.dart';
import 'package:pokedex_application/auth/domain/auth_failure_f.dart';
import 'package:pokedex_application/auth/domain/token_storage.dart';
import 'package:pokedex_application/auth/domain/user.dart';
import 'package:pokedex_application/auth/infrastructure/auth_interceptor.dart';
import 'package:pokedex_application/auth/infrastructure/auth_remote_service.dart';
import 'package:pokedex_application/auth/infrastructure/secure_token_storage.dart';
import 'package:pokedex_application/core/dio_api.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(aOptions: AndroidOptions());
});

final tokenStorageProvider = Provider<ITokenStorage>((ref) {
  return SecureTokenStorage(ref.watch(secureStorageProvider));
});

final authRemoteServiceProvider = Provider<AuthRemoteService>((ref) {
  final dioApi = ref.watch(authDioApiProvider);
  return AuthRemoteService(dioApi);
});

final authNotifierProvider =
    legacy.StateNotifierProvider<AuthNotifier, AuthState>((ref) {
      return AuthNotifier(
        ref.watch(tokenStorageProvider),
        ref.watch(authRemoteServiceProvider),
      );
    });

final authDioApiProvider = Provider<DioApi>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  return DioApi.withConfig(
    baseUrl: 'https://imprudently-isotactic-neymar.ngrok-free.dev',
    interceptors: [
      AuthInterceptor(
        tokenStorage: tokenStorage,
        onUnauthenticated: () {
          tokenStorage.clearToken();
        },
      ),
    ],
  );
});

class AuthNotifier extends legacy.StateNotifier<AuthState> {
  final ITokenStorage _tokenStorage;
  final AuthRemoteService _authRemoteService;

  AuthNotifier(this._tokenStorage, this._authRemoteService)
    : super(const AuthState.initial()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final token = await _tokenStorage.getToken();

    if (token != null && token.isNotEmpty) {
      _authRemoteService.dioApi.setAuthToken(token);
      state = AuthState.authenticated(
        User(
          id: 1,
          username: 'Signed in',
          email: 'user@pokedex.app',
          password: '',
        ),
      );
    } else {
      _authRemoteService.dioApi.clearAuthToken();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    final normalizedEmail = email.trim();
    final normalizedPassword = password.trim();

    if (normalizedEmail.isEmpty || normalizedPassword.isEmpty) {
      state = const AuthState.failure(
        AuthFailure.inValidCredentials(
          'Please enter your username or email and password.',
        ),
      );
      return;
    }

    try {
      final result = await _authRemoteService.loginUser(
        normalizedEmail,
        normalizedPassword,
      );

      await _tokenStorage.saveToken(result.token);
      _authRemoteService.dioApi.setAuthToken(result.token);

      state = AuthState.authenticated(result.user.toDomain());
    } catch (error) {
      state = AuthState.failure(AuthFailure.server(error.toString()));
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    final normalizedEmail = email.trim();
    final normalizedPassword = password.trim();

    if (normalizedUsername.isEmpty ||
        normalizedEmail.isEmpty ||
        normalizedPassword.isEmpty) {
      state = const AuthState.failure(
        AuthFailure.inValidCredentials(
          'Please fill in every field to create your account.',
        ),
      );
      return;
    }

    if (!normalizedEmail.contains('@')) {
      state = const AuthState.failure(
        AuthFailure.inValidCredentials('Please enter a valid email address.'),
      );
      return;
    }

    try {
      final result = await _authRemoteService.registerUser(
        normalizedUsername,
        normalizedEmail,
        normalizedPassword,
      );

      await _tokenStorage.saveToken(result.token);
      _authRemoteService.dioApi.setAuthToken(result.token);

      state = AuthState.authenticated(result.user.toDomain());
    } catch (error) {
      state = AuthState.failure(AuthFailure.server(error.toString()));
    }
  }

  Future<void> signOut() async {
    await _tokenStorage.clearToken();
    _authRemoteService.dioApi.clearAuthToken();
    state = const AuthState.unauthenticated();
  }
}
