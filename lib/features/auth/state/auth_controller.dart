import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_demo/features/auth/data/auth_service.dart';

enum AuthStatus { loggedOut, loading, authenticated }

class AuthController extends ChangeNotifier {
  AuthController({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;
  static const Duration _refreshSkew = Duration(seconds: 60);

  AuthStatus _status = AuthStatus.loggedOut;
  AuthSession? _session;
  String? _errorMessage;
  Timer? _refreshTimer;
  bool _initialized = false;

  AuthStatus get status => _status;
  AuthSession? get session => _session;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    final restored = await _authService.restoreSession();
    if (restored == null) {
      return;
    }

    _session = restored;
    _status = AuthStatus.authenticated;
    notifyListeners();
    await ensureFreshSession();
    _scheduleRefresh();
  }

  Future<void> signIn() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _session = await _authService.signIn();
      await _authService.persistSession(_session!);
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      _scheduleRefresh();
    } on AuthCancelledException catch (error) {
      _status = AuthStatus.loggedOut;
      _session = null;
      _errorMessage = error.message;
    } on AuthException catch (error) {
      _status = AuthStatus.loggedOut;
      _session = null;
      _errorMessage = error.message;
    } catch (_) {
      _status = AuthStatus.loggedOut;
      _session = null;
      _errorMessage = 'Unexpected auth error. Please try again.';
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final currentSession = _session;
    _refreshTimer?.cancel();
    await _authService.signOut(currentSession);
    await _authService.clearSession();

    _session = null;
    _status = AuthStatus.loggedOut;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> ensureFreshSession() async {
    final current = _session;
    if (current == null) {
      return false;
    }

    if (!_shouldRefresh(current)) {
      return true;
    }

    if (!current.canRefresh) {
      await _expireSession('Session expired. Please sign in again.');
      return false;
    }

    try {
      final refreshed = await _authService.refreshSession(current);
      _session = refreshed;
      await _authService.persistSession(refreshed);
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      _scheduleRefresh();
      notifyListeners();
      return true;
    } on AuthException catch (error) {
      await _expireSession(error.message);
      return false;
    } catch (_) {
      await _expireSession('Session expired. Please sign in again.');
      return false;
    }
  }

  bool _shouldRefresh(AuthSession session) {
    final expiresAt = session.expiresAt;
    if (expiresAt == null) {
      return false;
    }
    final now = DateTime.now().toUtc();
    return expiresAt.isBefore(now.add(_refreshSkew));
  }

  void _scheduleRefresh() {
    _refreshTimer?.cancel();
    final current = _session;
    if (current == null || !current.canRefresh) {
      return;
    }

    final expiresAt = current.expiresAt;
    if (expiresAt == null) {
      return;
    }

    final now = DateTime.now().toUtc();
    final refreshAt = expiresAt.subtract(_refreshSkew);
    final delay = refreshAt.difference(now);
    if (delay.isNegative) {
      unawaited(ensureFreshSession());
      return;
    }

    _refreshTimer = Timer(delay, () {
      unawaited(ensureFreshSession());
    });
  }

  Future<void> _expireSession(String message) async {
    _refreshTimer?.cancel();
    _session = null;
    _status = AuthStatus.loggedOut;
    _errorMessage = message;
    await _authService.clearSession();
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
