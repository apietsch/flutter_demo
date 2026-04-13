import 'dart:async';

import 'package:http/http.dart' as http;

abstract class LoremTextLoader {
  Future<String> fetchText(String url);
}

class LoremRepository implements LoremTextLoader {
  LoremRepository({
    required http.Client client,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client;

  final http.Client _client;
  final Duration timeout;

  @override
  Future<String> fetchText(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      throw const LoremLoadException('Please enter a valid absolute URL.');
    }

    try {
      final response = await _client.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        throw LoremLoadException(
          'Request failed with status ${response.statusCode}.',
        );
      }

      final text = response.body.trim();
      if (text.isEmpty) {
        throw const LoremLoadException('No content returned.');
      }

      return text;
    } on TimeoutException {
      throw const LoremLoadException('Request timed out. Please try again.');
    } on http.ClientException catch (error) {
      throw LoremLoadException('Network error: ${error.message}');
    }
  }
}

class LoremLoadException implements Exception {
  const LoremLoadException(this.message);

  final String message;

  @override
  String toString() => message;
}
