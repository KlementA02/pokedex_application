import 'package:meta/meta.dart';

@immutable
abstract class AuthFailure {
  const AuthFailure._();

  const factory AuthFailure.server(String message) = _Server;
  const factory AuthFailure.storage() = _Storage;
  const factory AuthFailure.inValidCredentials([String? message]) = _InvalidCredentials;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function() storage,
    required TResult Function(String? message) inValidCredentials,
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function()? storage,
    TResult? Function(String? message)? inValidCredentials,
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function()? storage,
    TResult Function(String? message)? inValidCredentials,
    required TResult orElse(),
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_Storage value) storage,
    required TResult Function(_InvalidCredentials value) inValidCredentials,
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_Storage value)? storage,
    TResult? Function(_InvalidCredentials value)? inValidCredentials,
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_Storage value)? storage,
    TResult Function(_InvalidCredentials value)? inValidCredentials,
    required TResult orElse(),
  }) {
    throw UnsupportedError('Please use subclass implementations.');
  }
}

// ==========================================================================
// 1. Server Implementation
// ==========================================================================
class _Server extends AuthFailure {
  final String message;
  const _Server(this.message) : super._();

  _Server copyWith({String? message}) {
    return _Server(message ?? this.message);
  }

  @override
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function() storage,
    required TResult Function(String? message) inValidCredentials,
  }) => server(message);

  @override
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function()? storage,
    TResult? Function(String? message)? inValidCredentials,
  }) => server?.call(message);

  @override
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function()? storage,
    TResult Function(String? message)? inValidCredentials,
    required TResult orElse(),
  }) => server != null ? server(message) : orElse();

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_Storage value) storage,
    required TResult Function(_InvalidCredentials value) inValidCredentials,
  }) => server(this);

  @override
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_Storage value)? storage,
    TResult? Function(_InvalidCredentials value)? inValidCredentials,
  }) => server?.call(this);

  @override
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_Storage value)? storage,
    TResult Function(_InvalidCredentials value)? inValidCredentials,
    required TResult orElse(),
  }) => server != null ? server(this) : orElse();

  @override
  String toString() => 'AuthFailure.server(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _Server && other.message == message);

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

// ==========================================================================
// 2. Storage Implementation
// ==========================================================================
class _Storage extends AuthFailure {
  const _Storage() : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function() storage,
    required TResult Function(String? message) inValidCredentials,
  }) => storage();

  @override
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function()? storage,
    TResult? Function(String? message)? inValidCredentials,
  }) => storage?.call();

  @override
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function()? storage,
    TResult Function(String? message)? inValidCredentials,
    required TResult orElse(),
  }) => storage != null ? storage() : orElse();

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_Storage value) storage,
    required TResult Function(_InvalidCredentials value) inValidCredentials,
  }) => storage(this);

  @override
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_Storage value)? storage,
    TResult? Function(_InvalidCredentials value)? inValidCredentials,
  }) => storage?.call(this);

  @override
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_Storage value)? storage,
    TResult Function(_InvalidCredentials value)? inValidCredentials,
    required TResult orElse(),
  }) => storage != null ? storage(this) : orElse();

  @override
  String toString() => 'AuthFailure.storage()';

  @override
  bool operator ==(Object other) => identical(this, other) || (other is _Storage);

  @override
  int get hashCode => runtimeType.hashCode;
}

// ==========================================================================
// 3. Invalid Credentials Implementation
// ==========================================================================
class _InvalidCredentials extends AuthFailure {
  final String? message;
  const _InvalidCredentials([this.message]) : super._();

  _InvalidCredentials copyWith({String? message}) {
    return _InvalidCredentials(message ?? this.message);
  }

  @override
  TResult when<TResult extends Object?>({
    required TResult Function(String message) server,
    required TResult Function() storage,
    required TResult Function(String? message) inValidCredentials,
  }) => inValidCredentials(message);

  @override
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? server,
    TResult? Function()? storage,
    TResult? Function(String? message)? inValidCredentials,
  }) => inValidCredentials?.call(message);

  @override
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? server,
    TResult Function()? storage,
    TResult Function(String? message)? inValidCredentials,
    required TResult orElse(),
  }) => inValidCredentials != null ? inValidCredentials(message) : orElse();

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_Storage value) storage,
    required TResult Function(_InvalidCredentials value) inValidCredentials,
  }) => inValidCredentials(this);

  @override
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_Storage value)? storage,
    TResult? Function(_InvalidCredentials value)? inValidCredentials,
  }) => inValidCredentials?.call(this);

  @override
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_Storage value)? storage,
    TResult Function(_InvalidCredentials value)? inValidCredentials,
    required TResult orElse(),
  }) => inValidCredentials != null ? inValidCredentials(this) : orElse();

  @override
  String toString() => 'AuthFailure.inValidCredentials(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _InvalidCredentials && other.message == message);

  @override
  int get hashCode => Object.hash(runtimeType, message);
}