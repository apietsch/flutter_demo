import 'package:flutter/material.dart';
import 'package:flutter_demo/features/screening/ui/screening_workspace_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('filters papers by selected screening status', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ScreeningWorkspacePage()),
    );

    final listFinder = find.byType(Scrollable).last;
    final alzheimerTitle = find.textContaining('Alzheimer');
    final crisprTitle = find.textContaining('CRISPR-Cas9');

    await tester.scrollUntilVisible(alzheimerTitle, 300, scrollable: listFinder);
    expect(alzheimerTitle, findsOneWidget);
    await tester.scrollUntilVisible(crisprTitle, -300, scrollable: listFinder);
    expect(crisprTitle, findsOneWidget);

    await tester.tap(find.text('Unscreened (2)'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(alzheimerTitle, 300, scrollable: listFinder);
    expect(alzheimerTitle, findsOneWidget);
    expect(crisprTitle, findsNothing);
  });

  testWidgets('exclude flow preserves cancel and applies saved note', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ScreeningWorkspacePage()),
    );

    final listFinder = find.byType(Scrollable).last;
    final paperTitle = find.textContaining('Alzheimer');

    await tester.tap(find.text('Unscreened (2)'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(paperTitle, 300, scrollable: listFinder);
    expect(paperTitle, findsOneWidget);

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Exclude').first);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Exclude').first);
    await tester.pumpAndSettle();

    expect(find.text('Exclude Note'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Exclude Note'), findsNothing);
    expect(find.text('Note: Safety concern'), findsNothing);
    expect(paperTitle, findsOneWidget);
    expect(find.text('Excluded (2)'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Exclude').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Safety concern');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Excluded (3)'), findsOneWidget);

    await tester.tap(find.text('Excluded (3)'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(paperTitle, 300, scrollable: listFinder);

    expect(paperTitle, findsOneWidget);
  });
}
