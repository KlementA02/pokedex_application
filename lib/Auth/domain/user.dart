import 'package:meta/meta.dart';

@immutable
class User {
  final int id;
  final String username;
  final String email;
  final String password;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  /// Factory blueprint matching Freezed's syntax pattern
  factory User.create({
    required int id,
    required String username,
    required String email,
    required String password,
  }) = _User;

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, password: [PROTECTED])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(id, username, email, password);
}

/// Hidden implementation class to fully mirror Freezed's internal architecture
class _User extends User {
  const _User({
    required super.id,
    required super.username,
    required super.email,
    required super.password,
  });
}