import 'package:innox/auth/infrastructure/user_dto.dart';
import 'package:innox/core/infrastructure/innox_db.dart';
import 'package:sembast/sembast.dart';

class UserStore {
  final InnoxDB _db;
  final StoreRef<int, Map<String, dynamic>> _store;

  UserStore({required InnoxDB database})
      : _db = database,
        _store = intMapStoreFactory.store('user');

  Future<void> saveUser(UserDTO userDTO, int id) async {
    await _store.record(id).put(_db.instance, userDTO.toJson());
  }

  Future<List<UserDTO>> getAllUsers() async {
    final finder = Finder(sortOrders: [SortOrder(Field.key)]);
    final records = await _store.find(_db.instance, finder: finder);
    return records.map((snapshot) {
      final userDTO = UserDTO.fromJson(snapshot.value);
      return userDTO;
    }).toList();
  }

  Future<void> updateUser(int id, UserDTO updatedUser) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _store.update(_db.instance, updatedUser.toJson(), finder: finder);
  }

  Future<void> deleteUser(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _store.delete(_db.instance, finder: finder);
  }

  Future<void> deleteAllUsers() async {
    await _store.delete(_db.instance);
  }
}
