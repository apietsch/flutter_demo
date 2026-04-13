import 'package:flutter/material.dart';
import 'package:flutter_demo/features/auth/data/auth_service.dart';
import 'package:flutter_demo/features/auth/state/auth_controller.dart';
import 'package:flutter_demo/features/lorem/data/lorem_repository.dart';
import 'package:flutter_demo/features/lorem/ui/lorem_loader_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows sign-in prompt and disables loading when logged out', (
    tester,
  ) async {
    final authController = AuthController(
      authService: _FakeAuthService.loggedOut(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LoremLoaderPage(
          loader: _FakeLoader.success('Lorem ipsum'),
          authController: authController,
        ),
      ),
    );

    expect(find.text('Authentication'), findsOneWidget);
    expect(find.text('Sign in with Keycloak'), findsOneWidget);

    final loadButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Load'),
    );
    expect(loadButton.onPressed, isNull);
  });

  testWidgets('enables loading and renders content when authenticated', (
    tester,
  ) async {
    final authController = AuthController(
      authService: _FakeAuthService.loggedIn(),
    );
    await authController.signIn();

    await tester.pumpWidget(
      MaterialApp(
        home: LoremLoaderPage(
          loader: _FakeLoader.success('Lorem ipsum dolor sit amet'),
          authController: authController,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Load'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Lorem ipsum dolor sit amet'), findsOneWidget);
  });
}

class _FakeLoader implements LoremTextLoader {
  _FakeLoader.success(this._text) : _error = null;

  final String _text;
  final Exception? _error;

  @override
  Future<String> fetchText(String url) async {
    final error = _error;
    if (error != null) {
      throw error;
    }
    return _text;
  }
}

class _FakeAuthService implements AuthService {
  _FakeAuthService.loggedOut() : _session = null;

  _FakeAuthService.loggedIn()
    : _session = const AuthSession(
        accessToken: 'token',
        idToken: 'id',
        refreshToken: 'refresh',
        email: 'demo@example.com',
        preferredUsername: 'demo',
      );

  final AuthSession? _session;

  @override
  Future<AuthSession> signIn() async {
    if (_session == null) {
      throw const AuthException('Not authenticated');
    }
    return _session;
  }

  @override
  Future<void> signOut(AuthSession? session) async {}
}
