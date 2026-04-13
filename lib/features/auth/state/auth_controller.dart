import 'package:flutter/foundation.dart';
import 'package:flutter_demo/features/auth/data/auth_service.dart';

enum AuthStatus { loggedOut, loading, authenticated }

class AuthController extends ChangeNotifier {
  AuthController({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;

  AuthStatus _status = AuthStatus.loggedOut;
  AuthSession? _session;
  String? _errorMessage;

  AuthStatus get status => _status;
  AuthSession? get session => _session;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> signIn() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _session = await _authService.signIn();
      _status = AuthStatus.authenticated;
      _errorMessage = null;
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
    await _authService.signOut(currentSession);

    _session = null;
    _status = AuthStatus.loggedOut;
    _errorMessage = null;
    notifyListeners();
  }
}
