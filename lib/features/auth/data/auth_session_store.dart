import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSessionStore {
  AuthSessionStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _sessionKey = 'auth_session';
  final FlutterSecureStorage _storage;

  Future<void> save(Map<String, dynamic> jsonMap) async {
    await _storage.write(key: _sessionKey, value: json.encode(jsonMap));
  }

  Future<Map<String, dynamic>?> load() async {
    final data = await _storage.read(key: _sessionKey);
    if (data == null || data.isEmpty) {
      return null;
    }

    try {
      final decoded = json.decode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      await clear();
      return null;
    }

    await clear();
    return null;
  }

  Future<void> clear() async {
    await _storage.delete(key: _sessionKey);
  }
}
