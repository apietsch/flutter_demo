import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSessionStore {
  AuthSessionStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _sessionKey = 'auth_session';
  static const String _rememberMeKey = 'remember_me';
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

  Future<void> saveRememberMe(bool value) async {
    await _storage.write(key: _rememberMeKey, value: value ? '1' : '0');
  }

  Future<bool> loadRememberMe() async {
    final value = await _storage.read(key: _rememberMeKey);
    return value == '1';
  }
}
