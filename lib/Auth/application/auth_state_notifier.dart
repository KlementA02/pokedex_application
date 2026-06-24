import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:innox/auth/application/login_form_state.dart';
import 'package:innox/auth/domain/auth_failure.dart';
import 'package:innox/auth/domain/user.dart';
import 'package:innox/auth/infrastructure/innox_authenticator.dart';
part 'auth_state_notifier.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.failure({required AuthFailure authFailure}) =
      _Failure;
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final IAuthenticator _authenticator;
  static User? user;
  AuthStateNotifier(this._authenticator) : super(const AuthState.initial());

  Future<void> checkAndUpdateStatus() async {
    try {
      final isSignedIn = await _authenticator.isSignedIn();
      if (isSignedIn) {
        user ??= await _authenticator.getSignedInUser();
      }
      state = isSignedIn
          ? const AuthState.authenticated()
          : const AuthState.unauthenticated();
    } catch (e) {
      debugPrint('❌ checkAndUpdateStatus error: $e');
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> getSignedInUser() async {
    final _ = await _authenticator.getSignedInUser();
    if (_ != null) {
      user = _;
    }
  }

  Future<void> login({
    required LoginFormState formState,
    VoidCallback? onSuccess,
  }) async {
    state = const AuthState.initial();
    final result = await _authenticator.login(
        formState.userName, formState.password, formState.server);
    await result.fold(
          (failure) async => state = AuthState.failure(authFailure: failure),
          (_) async {
            await checkAndUpdateStatus();
            onSuccess?.call();
          }
    );
  }

  Future<void> logout() async {
    user = null;
    final result = await _authenticator.logout();
    state = result.fold(
          (failure) => AuthState.failure(authFailure: failure),
          (_) => const AuthState.unauthenticated(),
    );
  }

  static String? getUserName() {
    return user?.usaUserName;
  }

  static String? getFirstName() {
    return user?.empFirstName;
  }
}
