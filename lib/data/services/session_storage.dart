import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_account.dart';

class SessionStorage {
  static const _tokenKey = 'chamba_jwt_token';
  static const _userKey = 'chamba_user_data';

  final FlutterSecureStorage _storage;

  SessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserAccount user) async {
    final jsonStr = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: jsonStr);
  }

  Future<UserAccount?> getUser() async {
    try {
      final jsonStr = await _storage.read(key: _userKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserAccount.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } catch (_) {
      // Ignore cleanup error
    }
  }
}
