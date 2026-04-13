import 'package:flutter_demo/features/lorem/data/lorem_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns text on HTTP 200', () async {
    final repo = LoremRepository(
      client: MockClient((request) async => http.Response('lorem ipsum', 200)),
    );

    final result = await repo.fetchText('https://example.com/lorem.txt');
    expect(result, 'lorem ipsum');
  });

  test('throws friendly error on non-200 response', () async {
    final repo = LoremRepository(
      client: MockClient((request) async => http.Response('server error', 500)),
    );

    expect(
      () => repo.fetchText('https://example.com/lorem.txt'),
      throwsA(
        isA<LoremLoadException>().having(
          (error) => error.message,
          'message',
          'Request failed with status 500.',
        ),
      ),
    );
  });

  test('rejects invalid URLs before sending request', () async {
    final repo = LoremRepository(
      client: MockClient(
        (request) async => http.Response('should not be called', 200),
      ),
    );

    expect(
      () => repo.fetchText('not-a-url'),
      throwsA(
        isA<LoremLoadException>().having(
          (error) => error.message,
          'message',
          'Please enter a valid absolute URL.',
        ),
      ),
    );
  });
}
