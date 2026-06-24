import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<void> wipeSecureStorageFiles() async {
  try {
    const testStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
      ),
    );
    await testStorage.readAll();
  } catch (e) {
    debugPrint("Corrupt storage detected. Wiping files directly...");
    try {
      final appDir = await getApplicationSupportDirectory();
      final sharedPrefsDir = Directory(
        '${appDir.parent.path}/shared_prefs',
      );

      if (await sharedPrefsDir.exists()) {
        final files = sharedPrefsDir.listSync();
        for (final file in files) {
          final name = file.path.split('/').last;
          if (name.contains('FlutterSecureStorage') ||
              name.contains('com.it_nomads') ||
              name.contains('flutter_secure') ||
              name.contains('encrypted_shared_preferences')) {
            debugPrint("Deleting: $name");
            await file.delete();
          }
        }
      }
    } catch (dirError) {
      debugPrint("File wipe failed: $dirError");
    }
  }
}