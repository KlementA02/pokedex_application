import 'package:meta/meta.dart';
import 'package:pokedex_application/auth/domain/user.dart';

@immutable
class UserDto {
  final int id;
  final String username;
  final String email;
  final String password;

  const UserDto({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  /// Factory constructor to parse raw incoming network JSON maps
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  /// Converts the DTO back to a JSON map for remote API payloads
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  /// DDD Mapper: Converts data layer DTO into a pure domain entity
  User toDomain() {
    return User(
      id: id,
      username: username,
      email: email,
      password: password,
    );
  }

  /// DDD Mapper: Creates a data layer DTO from an existing domain entity
  factory UserDto.fromDomain(User domain) {
    return UserDto(
      id: domain.id,
      username: domain.username,
      email: domain.email,
      password: domain.password,
    );
  }

  UserDto copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
  }) {
    return UserDto(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'UserDto(id: $id, username: $username, email: $email, password: [PROTECTED])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDto &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(id, username, email, password);
}