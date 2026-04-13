import 'package:flutter/material.dart';
import 'package:flutter_demo/features/lorem/data/lorem_repository.dart';
import 'package:flutter_demo/features/lorem/ui/lorem_loader_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp(loader: LoremRepository(client: http.Client())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.loader});

  final LoremTextLoader loader;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lorem Loader Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: LoremLoaderPage(loader: loader),
    );
  }
}
