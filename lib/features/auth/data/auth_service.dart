import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_demo/features/auth/config/auth_config.dart';
import 'package:flutter_demo/features/auth/data/auth_session_store.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
    required this.email,
    required this.preferredUsername,
    required this.expiresAt,
  });

  final String accessToken;
  final String? idToken;
  final String? refreshToken;
  final String? email;
  final String? preferredUsername;
  final DateTime? expiresAt;

  bool get canRefresh => refreshToken != null && refreshToken!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'idToken': idToken,
      'refreshToken': refreshToken,
      'email': email,
      'preferredUsername': preferredUsername,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  static AuthSession? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final accessToken = json['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    final expiresRaw = json['expiresAt'] as String?;
    DateTime? expiresAt;
    if (expiresRaw != null && expiresRaw.isNotEmpty) {
      expiresAt = DateTime.tryParse(expiresRaw)?.toUtc();
    }

    return AuthSession(
      accessToken: accessToken,
      idToken: json['idToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      email: json['email'] as String?,
      preferredUsername: json['preferredUsername'] as String?,
      expiresAt: expiresAt,
    );
  }
}

abstract class AuthService {
  Future<AuthSession> signIn();
  Future<AuthSession> refreshSession(AuthSession currentSession);
  Future<void> signOut(AuthSession? session);
  Future<AuthSession?> restoreSession();
  Future<void> persistSession(AuthSession session);
  Future<void> clearSession();
}

class OidcAuthService implements AuthService {
  OidcAuthService({
    required FlutterAppAuth appAuth,
    required AuthSessionStore sessionStore,
  }) : _appAuth = appAuth,
       _sessionStore = sessionStore;

  final FlutterAppAuth _appAuth;
  final AuthSessionStore _sessionStore;

  @override
  Future<AuthSession> signIn() async {
    try {
      final token = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AuthConfig.clientId,
          AuthConfig.redirectUri,
          issuer: AuthConfig.issuer,
          scopes: AuthConfig.scopes,
        ),
      );

      if (token.accessToken == null) {
        throw const AuthException('No token received from identity provider.');
      }

      return _fromTokenResponse(token);
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
  Future<AuthSession> refreshSession(AuthSession currentSession) async {
    final refreshToken = currentSession.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const AuthException('No refresh token available.');
    }

    try {
      final token = await _appAuth.token(
        TokenRequest(
          AuthConfig.clientId,
          AuthConfig.redirectUri,
          issuer: AuthConfig.issuer,
          refreshToken: refreshToken,
          scopes: AuthConfig.scopes,
        ),
      );

      if (token.accessToken == null) {
        throw const AuthException('Failed to refresh session.');
      }

      return _fromTokenResponse(
        token,
        fallbackIdToken: currentSession.idToken,
        fallbackRefreshToken: refreshToken,
      );
    } on PlatformException catch (error) {
      throw AuthException(error.message ?? 'Failed to refresh session.');
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

  @override
  Future<AuthSession?> restoreSession() async {
    final json = await _sessionStore.load();
    return AuthSession.fromJson(json);
  }

  @override
  Future<void> persistSession(AuthSession session) async {
    await _sessionStore.save(session.toJson());
  }

  @override
  Future<void> clearSession() async {
    await _sessionStore.clear();
  }

  bool _isUserCancel(PlatformException error) {
    final message = (error.message ?? '').toLowerCase();
    return message.contains('cancel') || message.contains('canceled');
  }

  AuthSession _fromTokenResponse(
    TokenResponse token, {
    String? fallbackIdToken,
    String? fallbackRefreshToken,
  }) {
    final claims = _readJwtClaims(token.idToken ?? fallbackIdToken);
    return AuthSession(
      accessToken: token.accessToken!,
      idToken: token.idToken ?? fallbackIdToken,
      refreshToken: token.refreshToken ?? fallbackRefreshToken,
      email: claims['email'] as String?,
      preferredUsername: claims['preferred_username'] as String?,
      expiresAt: token.accessTokenExpirationDateTime?.toUtc(),
    );
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
