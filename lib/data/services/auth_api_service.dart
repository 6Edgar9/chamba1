import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_account.dart';

class AuthApiException implements Exception {
  final String message;
  final int? statusCode;

  const AuthApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class AuthResponse {
  final UserAccount user;
  final String accessToken;
  final String? message;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.message,
  });
}

class AuthApiService {
  final String baseUrl;
  final http.Client _client;

  AuthApiService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? _resolveDefaultBaseUrl(),
        _client = client ?? http.Client();

  static String _resolveDefaultBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    try {
      if (Platform.isAndroid) {
        // Android Emulator maps host localhost to 10.0.2.2
        return 'http://10.0.2.2:3000';
      }
    } catch (_) {
      // In case Platform is unavailable
    }
    return 'http://localhost:3000';
  }

  Map<String, String> _headers([String? token]) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<AuthResponse> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? district,
    String? address,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/auth/register');
    final payload = {
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      if (district != null && district.trim().isNotEmpty) 'district': district.trim(),
      if (address != null && address.trim().isNotEmpty) 'address': address.trim(),
    };

    try {
      final response = await _client.post(
        uri,
        headers: _headers(),
        body: jsonEncode(payload),
      );

      final body = _parseJson(response.body);

      if (response.statusCode == 201) {
        final user = UserAccount.fromJson(body['user'] as Map<String, dynamic>);
        final token = body['accessToken'] as String;
        return AuthResponse(
          user: user,
          accessToken: token,
          message: body['message'] as String?,
        );
      } else if (response.statusCode == 409) {
        throw AuthApiException(
          body['message']?.toString() ?? 'El correo electrónico ya está registrado',
          409,
        );
      } else {
        throw AuthApiException(
          _extractErrorMessage(body, 'Error al registrar el usuario'),
          response.statusCode,
        );
      }
    } on SocketException {
      throw const AuthApiException(
        'No se pudo conectar con el servidor backend CHAMBA. Verifica que esté en ejecución en el puerto 3000.',
      );
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw AuthApiException('Error de conexión: $e');
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/auth/login');
    final payload = {
      'email': email.trim().toLowerCase(),
      'password': password,
    };

    try {
      final response = await _client.post(
        uri,
        headers: _headers(),
        body: jsonEncode(payload),
      );

      final body = _parseJson(response.body);

      if (response.statusCode == 200) {
        final user = UserAccount.fromJson(body['user'] as Map<String, dynamic>);
        final token = body['accessToken'] as String;
        return AuthResponse(
          user: user,
          accessToken: token,
          message: body['message'] as String?,
        );
      } else if (response.statusCode == 401) {
        throw const AuthApiException('Correo electrónico o contraseña incorrectos', 401);
      } else {
        throw AuthApiException(
          _extractErrorMessage(body, 'Error al iniciar sesión'),
          response.statusCode,
        );
      }
    } on SocketException {
      throw const AuthApiException(
        'No se pudo conectar con el servidor backend CHAMBA. Verifica que esté en ejecución en el puerto 3000.',
      );
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw AuthApiException('Error de conexión: $e');
    }
  }

  Future<UserAccount> getMe(String token) async {
    final uri = Uri.parse('$baseUrl/api/v1/users/me');

    try {
      final response = await _client.get(
        uri,
        headers: _headers(token),
      );

      final body = _parseJson(response.body);

      if (response.statusCode == 200) {
        return UserAccount.fromJson(body);
      } else if (response.statusCode == 401) {
        throw const AuthApiException('Sesión expirada o no autorizada', 401);
      } else {
        throw AuthApiException(
          _extractErrorMessage(body, 'Error al consultar perfil de usuario'),
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw AuthApiException('Error al consultar perfil: $e');
    }
  }

  Future<UserAccount> updateMe(
    String token, {
    String? fullName,
    String? phone,
    String? district,
    String? address,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/users/me');
    final payload = {
      if (fullName != null) 'fullName': fullName.trim(),
      if (phone != null) 'phone': phone.trim(),
      if (district != null) 'district': district.trim(),
      if (address != null) 'address': address.trim(),
    };

    try {
      final response = await _client.patch(
        uri,
        headers: _headers(token),
        body: jsonEncode(payload),
      );

      final body = _parseJson(response.body);

      if (response.statusCode == 200) {
        return UserAccount.fromJson(body);
      } else {
        throw AuthApiException(
          _extractErrorMessage(body, 'Error al actualizar perfil'),
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw AuthApiException('Error al actualizar perfil: $e');
    }
  }

  Future<WorkerProfileData> upsertWorkerProfile(
    String token, {
    required String bio,
    required String specialty,
    String? district,
    bool isAvailable = true,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/worker-profile/me');
    final payload = {
      'bio': bio.trim(),
      'specialty': specialty.trim(),
      if (district != null) 'district': district.trim(),
      'isAvailable': isAvailable,
    };

    try {
      final response = await _client.put(
        uri,
        headers: _headers(token),
        body: jsonEncode(payload),
      );

      final body = _parseJson(response.body);

      if (response.statusCode == 200) {
        return WorkerProfileData.fromJson(body);
      } else {
        throw AuthApiException(
          _extractErrorMessage(body, 'Error al guardar perfil de trabajador'),
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw AuthApiException('Error al guardar perfil de trabajador: $e');
    }
  }

  Map<String, dynamic> _parseJson(String text) {
    try {
      return jsonDecode(text) as Map<String, dynamic>;
    } catch (_) {
      return {'message': text};
    }
  }

  String _extractErrorMessage(Map<String, dynamic> body, String fallback) {
    final msg = body['message'];
    if (msg is List) {
      return msg.join(', ');
    } else if (msg is String && msg.isNotEmpty) {
      return msg;
    }
    return fallback;
  }
}
