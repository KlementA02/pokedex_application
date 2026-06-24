abstract class SecuredCredentialsStorage {
  Future<void> save(String credentials);

  Future<String?> read();

  Future<void> clear();
}
