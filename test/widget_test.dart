import 'package:flutter/material.dart';
import 'package:flutter_demo/features/lorem/data/lorem_repository.dart';
import 'package:flutter_demo/features/lorem/ui/lorem_loader_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders controls on first load', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoremLoaderPage(loader: _FakeLoader.success('Lorem ipsum')),
      ),
    );

    expect(find.text('Lorem Loader'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text URL'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Load'), findsOneWidget);
    expect(
      find.text('Press "Load" to fetch lorem ipsum text.'),
      findsOneWidget,
    );
  });

  testWidgets('loads and shows text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoremLoaderPage(
          loader: _FakeLoader.success('Lorem ipsum dolor sit amet'),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Load'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Lorem ipsum dolor sit amet'), findsOneWidget);
  });

  testWidgets('shows error on failed fetch', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoremLoaderPage(
          loader: _FakeLoader.failure(
            const LoremLoadException('Request failed with status 500.'),
          ),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Load'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Request failed with status 500.'), findsOneWidget);
  });
}

class _FakeLoader implements LoremTextLoader {
  _FakeLoader.success(this._text) : _error = null;

  _FakeLoader.failure(this._error) : _text = null;

  final String? _text;
  final Exception? _error;

  @override
  Future<String> fetchText(String url) async {
    final error = _error;
    if (error != null) {
      throw error;
    }
    return _text ?? '';
  }
}
