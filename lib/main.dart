import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_demo/features/auth/data/auth_service.dart';
import 'package:flutter_demo/features/auth/data/auth_session_store.dart';
import 'package:flutter_demo/features/auth/state/auth_controller.dart';
import 'package:flutter_demo/features/lorem/data/lorem_repository.dart';
import 'package:flutter_demo/features/lorem/ui/lorem_loader_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MyApp(
      loader: LoremRepository(client: http.Client()),
      authController: AuthController(
        authService: OidcAuthService(
          appAuth: const FlutterAppAuth(),
          sessionStore: AuthSessionStore(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.loader, required this.authController});

  final LoremTextLoader loader;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lorem Loader Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: LoremLoaderPage(loader: loader, authController: authController),
    );
  }
}
