class AuthConfig {
  const AuthConfig._();

  static const String issuer = String.fromEnvironment(
    'AUTH_ISSUER',
    defaultValue: 'http://localhost:8080/realms/flutter-demo',
  );
  static const String clientId = String.fromEnvironment(
    'AUTH_CLIENT_ID',
    defaultValue: 'flutter-app',
  );
  static const String redirectUri = String.fromEnvironment(
    'AUTH_REDIRECT_URI',
    defaultValue: 'com.example.flutterDemo:/oauth2redirect',
  );
  static const String postLogoutRedirectUri = String.fromEnvironment(
    'AUTH_POST_LOGOUT_REDIRECT_URI',
    defaultValue: 'com.example.flutterDemo:/oauth2redirect',
  );
  static const bool localLogoutOnly = bool.fromEnvironment(
    'AUTH_LOCAL_LOGOUT_ONLY',
    defaultValue: true,
  );

  static const List<String> scopes = <String>['openid', 'profile', 'email'];
}
