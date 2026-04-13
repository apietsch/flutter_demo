import 'package:flutter_demo/features/auth/data/auth_service.dart';
import 'package:flutter_demo/features/auth/state/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signIn moves to authenticated on success', () async {
    final controller = AuthController(
      authService: _FakeAuthService(
        signInSession: _session(expiresInMinutes: 10),
      ),
    );

    await controller.signIn();

    expect(controller.status, AuthStatus.authenticated);
    expect(controller.session?.preferredUsername, 'demo');
    expect(controller.errorMessage, isNull);
  });

  test('initialize restores persisted session', () async {
    final controller = AuthController(
      authService: _FakeAuthService(
        restoredSession: _session(expiresInMinutes: 10),
      ),
    );

    await controller.initialize();

    expect(controller.status, AuthStatus.authenticated);
    expect(controller.session?.email, 'demo@example.com');
  });

  test('ensureFreshSession refreshes shortly expiring token', () async {
    final refreshed = _session(expiresInMinutes: 10, accessToken: 'new-token');
    final service = _FakeAuthService(
      restoredSession: _session(expiresInMinutes: 0, accessToken: 'old-token'),
      refreshedSession: refreshed,
    );
    final controller = AuthController(authService: service);
    await controller.initialize();

    final ok = await controller.ensureFreshSession();

    expect(ok, isTrue);
    expect(controller.status, AuthStatus.authenticated);
    expect(controller.session?.accessToken, 'new-token');
    expect(service.refreshCalls, 1);
  });

  test('ensureFreshSession logs out on refresh failure', () async {
    final service = _FakeAuthService(
      restoredSession: _session(expiresInMinutes: 0, accessToken: 'old-token'),
      refreshError: const AuthException('Failed to refresh session.'),
    );
    final controller = AuthController(authService: service);
    await controller.initialize();

    final ok = await controller.ensureFreshSession();

    expect(ok, isFalse);
    expect(controller.status, AuthStatus.loggedOut);
    expect(controller.session, isNull);
    expect(controller.errorMessage, 'Failed to refresh session.');
  });

  test('signOut clears session', () async {
    final controller = AuthController(
      authService: _FakeAuthService(
        signInSession: _session(expiresInMinutes: 10),
      ),
    );
    await controller.signIn();

    await controller.signOut();

    expect(controller.status, AuthStatus.loggedOut);
    expect(controller.session, isNull);
    expect(controller.errorMessage, isNull);
  });
}

AuthSession _session({
  required int expiresInMinutes,
  String accessToken = 'token',
}) {
  return AuthSession(
    accessToken: accessToken,
    idToken: 'id-token',
    refreshToken: 'refresh-token',
    email: 'demo@example.com',
    preferredUsername: 'demo',
    expiresAt: DateTime.now().toUtc().add(Duration(minutes: expiresInMinutes)),
  );
}

class _FakeAuthService implements AuthService {
  _FakeAuthService({
    this.signInSession,
    this.restoredSession,
    this.refreshedSession,
    this.refreshError,
  });

  final AuthSession? signInSession;
  final AuthSession? restoredSession;
  final AuthSession? refreshedSession;
  final AuthException? refreshError;
  int refreshCalls = 0;

  @override
  Future<void> clearSession() async {}

  @override
  Future<void> persistSession(AuthSession session) async {}

  @override
  Future<AuthSession?> restoreSession() async => restoredSession;

  @override
  Future<AuthSession> signIn() async {
    final session = signInSession;
    if (session == null) {
      throw const AuthException('Authentication failed.');
    }
    return session;
  }

  @override
  Future<void> signOut(AuthSession? session) async {}

  @override
  Future<AuthSession> refreshSession(AuthSession currentSession) async {
    refreshCalls++;
    final error = refreshError;
    if (error != null) {
      throw error;
    }
    final session = refreshedSession;
    if (session == null) {
      throw const AuthException('Failed to refresh session.');
    }
    return session;
  }
}
