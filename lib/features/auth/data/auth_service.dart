import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_demo/features/auth/config/auth_config.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
    required this.email,
    required this.preferredUsername,
  });

  final String accessToken;
  final String? idToken;
  final String? refreshToken;
  final String? email;
  final String? preferredUsername;
}

abstract class AuthService {
  Future<AuthSession> signIn();
  Future<void> signOut(AuthSession? session);
}

class OidcAuthService implements AuthService {
  OidcAuthService({required FlutterAppAuth appAuth}) : _appAuth = appAuth;

  final FlutterAppAuth _appAuth;

  @override
  Future<AuthSession> signIn() async {
    try {
      final token = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AuthConfig.clientId,
          AuthConfig.redirectUri,
          issuer: AuthConfig.issuer,
          scopes: AuthConfig.scopes,
          promptValues: const <String>['login'],
        ),
      );

      if (token.accessToken == null) {
        throw const AuthException('No token received from identity provider.');
      }

      final claims = _readJwtClaims(token.idToken);
      return AuthSession(
        accessToken: token.accessToken!,
        idToken: token.idToken,
        refreshToken: token.refreshToken,
        email: claims['email'] as String?,
        preferredUsername: claims['preferred_username'] as String?,
      );
    } on PlatformException catch (error) {
      if (_isUserCancel(error)) {
        throw const AuthCancelledException();
      }
      throw AuthException(
        error.message ?? 'Authentication failed. Please try again.',
      );
    }
  }

  @override
  Future<void> signOut(AuthSession? session) async {
    final idToken = session?.idToken;
    if (idToken == null) {
      return;
    }

    try {
      await _appAuth.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: AuthConfig.postLogoutRedirectUri,
          issuer: AuthConfig.issuer,
        ),
      );
    } on PlatformException {
      // Keep logout resilient; local session should still be cleared.
    }
  }

  bool _isUserCancel(PlatformException error) {
    final message = (error.message ?? '').toLowerCase();
    return message.contains('cancel') || message.contains('canceled');
  }

  Map<String, dynamic> _readJwtClaims(String? token) {
    if (token == null || token.isEmpty) {
      return const <String, dynamic>{};
    }

    final segments = token.split('.');
    if (segments.length < 2) {
      return const <String, dynamic>{};
    }

    try {
      final normalized = base64Url.normalize(segments[1]);
      final payload = utf8.decode(base64Url.decode(normalized));
      final jsonMap = json.decode(payload);
      if (jsonMap is Map<String, dynamic>) {
        return jsonMap;
      }
    } catch (_) {
      return const <String, dynamic>{};
    }

    return const <String, dynamic>{};
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthCancelledException extends AuthException {
  const AuthCancelledException() : super('Sign-in was canceled.');
}
