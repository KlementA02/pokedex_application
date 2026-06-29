import 'package:meta/meta.dart';
import 'package:pokedex_application/auth/domain/auth_failure.dart';
import 'package:pokedex_application/auth/domain/user.dart';

@immutable
abstract class AuthState {
  const AuthState._();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.failure(AuthFailure failure) = _Failure;

  // Pattern Matching Blueprints
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(AuthFailure failure) failure,
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }

  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(AuthFailure failure)? failure,
    required TResult orElse(),
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }
}

// ==========================================================================
// 1. Initial State Implementation
// ==========================================================================
class _Initial extends AuthState {
  const _Initial() : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(AuthFailure failure) failure,
  }) => initial();

  @override
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(AuthFailure failure)? failure,
    required TResult orElse(),
  }) => initial != null ? initial() : orElse();

  @override
  String toString() => 'AuthState.initial()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is _Initial);

  @override
  int get hashCode => runtimeType.hashCode;
}

// ==========================================================================
// 2. Authenticated State Implementation
// ==========================================================================
class _Authenticated extends AuthState {
  final User user;
  const _Authenticated(this.user) : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(AuthFailure failure) failure,
  }) => authenticated(user);

  @override
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(AuthFailure failure)? failure,
    required TResult orElse(),
  }) => authenticated != null ? authenticated(user) : orElse();

  @override
  String toString() => 'AuthState.authenticated(user: $user)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is _Authenticated && other.user == user);

  @override
  int get hashCode => Object.hash(runtimeType, user);
}

// ==========================================================================
// 3. Unauthenticated State Implementation
// ==========================================================================
class _Unauthenticated extends AuthState {
  const _Unauthenticated() : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(AuthFailure failure) failure,
  }) => unauthenticated();

  @override
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(AuthFailure failure)? failure,
    required TResult orElse(),
  }) => unauthenticated != null ? unauthenticated() : orElse();

  @override
  String toString() => 'AuthState.unauthenticated()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is _Unauthenticated);

  @override
  int get hashCode => runtimeType.hashCode;
}

// ==========================================================================
// 4. Failure State Implementation
// ==========================================================================
class _Failure extends AuthState {
  final AuthFailure failure;
  const _Failure(this.failure) : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(AuthFailure failure) failure,
  }) => failure(this.failure);

  @override
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(AuthFailure failure)? failure,
    required TResult orElse(),
  }) => failure != null ? failure(this.failure) : orElse();

  @override
  String toString() => 'AuthState.failure(failure: $failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is _Failure && other.failure == failure);

  @override
  int get hashCode => Object.hash(runtimeType, failure);
}
