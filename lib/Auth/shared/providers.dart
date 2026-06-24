import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:innox/auth/application/auth_state_notifier.dart';
import 'package:innox/auth/application/login_form_state.dart';
import 'package:innox/auth/infrastructure/credentials_storage/credentials_storage.dart';
import 'package:innox/auth/infrastructure/innox_authenticator.dart';
import 'package:innox/auth/infrastructure/user_store.dart';
import 'package:innox/core/infrastructure/dio_api.dart';
import 'package:innox/core/infrastructure/innox_db.dart';

import '../application/session_timeout_notifier.dart';

final _flutterSecuredCredentials = Provider((ref) => kSecureStorage);

final _dio = Provider((ref) => Dio());
final _powerDio = Provider((ref) => Dio());

final _api = Provider((ref) => DioAPI(
    dio: ref.watch(
      _dio,
    ),
    powerApp: false));
final powerApiProvider =
    Provider((ref) => DioAPI(dio: ref.watch(_powerDio), powerApp: true));

final _credentials = Provider((ref) =>
    CredentialsStorage(storage: ref.watch(_flutterSecuredCredentials)));

final userStoreProvider =
    Provider((ref) => UserStore(database: ref.watch(innoxDBProvider)));

final _iAuthenticator = Provider((ref) => IAuthenticator(
      credentialsStorage: ref.watch(_credentials),
      api: ref.watch(_api),
      userCache: ref.watch(userStoreProvider),
    ));

final loginFormStateProvider =
    StateNotifierProvider<LoginFormStateNotifier, LoginFormState>(
  (ref) => LoginFormStateNotifier(),
);

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(ref.watch(_iAuthenticator)),
);

final loadingStateProvider = StateProvider((ref) => false);

final authenticatorProvider = Provider<IAuthenticator>(
  (ref) => ref.watch(_iAuthenticator),
);

final profileDetailProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final authenticator = ref.watch(authenticatorProvider);
  return await authenticator.getFullProfileFromStorage();
});

final loginState = FutureProvider<Unit>((ref) async {
  await ref.read(authStateProvider.notifier).checkAndUpdateStatus();
  return unit;
});

const kSecureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
  ),
);

final sessionTimeoutProvider =
    StateNotifierProvider<SessionTimeoutNotifier, bool>(
  (ref) => SessionTimeoutNotifier(),
);

final lockedUsernameProvider = StateProvider<String?>((ref) => null);
final lockedUserLoginProvider = StateProvider<String?>((ref) => null);
