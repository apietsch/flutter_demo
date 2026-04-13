import 'package:flutter_demo/features/auth/data/auth_service.dart';
import 'package:flutter_demo/features/auth/state/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signIn moves to authenticated on success', () async {
    final controller = AuthController(
      authService: _FakeAuthService.success(
        const AuthSession(
          accessToken: 'token',
          idToken: 'id',
          refreshToken: 'refresh',
          email: 'demo@example.com',
          preferredUsername: 'demo',
        ),
      ),
    );

    await controller.signIn();

    expect(controller.status, AuthStatus.authenticated);
    expect(controller.session?.preferredUsername, 'demo');
    expect(controller.errorMessage, isNull);
  });

  test('signIn returns to loggedOut on failure', () async {
    final controller = AuthController(
      authService: _FakeAuthService.failure(
        const AuthException('Authentication failed.'),
      ),
    );

    await controller.signIn();

    expect(controller.status, AuthStatus.loggedOut);
    expect(controller.session, isNull);
    expect(controller.errorMessage, 'Authentication failed.');
  });

  test('signOut clears session', () async {
    final controller = AuthController(
      authService: _FakeAuthService.success(
        const AuthSession(
          accessToken: 'token',
          idToken: 'id',
          refreshToken: 'refresh',
          email: 'demo@example.com',
          preferredUsername: 'demo',
        ),
      ),
    );
    await controller.signIn();

    await controller.signOut();

    expect(controller.status, AuthStatus.loggedOut);
    expect(controller.session, isNull);
    expect(controller.errorMessage, isNull);
  });
}

class _FakeAuthService implements AuthService {
  _FakeAuthService.success(this._session) : _error = null;

  _FakeAuthService.failure(this._error) : _session = null;

  final AuthSession? _session;
  final Exception? _error;

  @override
  Future<AuthSession> signIn() async {
    final error = _error;
    if (error != null) {
      throw error;
    }
    return _session!;
  }

  @override
  Future<void> signOut(AuthSession? session) async {}
}
