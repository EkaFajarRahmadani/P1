import 'package:flutter/foundation.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/main.dart';

void main() {
  testWidgets('shows and updates the student profile', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Profil Mahasiswa'), findsOneWidget);
    expect(find.text('Nama Mahasiswa'), findsOneWidget);
    expect(find.text('NM'), findsOneWidget);

    final editButton = find.byKey(const Key('edit-profile-button'));
    await tester.ensureVisible(editButton);
    await tester.tap(editButton);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('name-field')), 'Ayu Pratama');
    await tester.tap(find.byKey(const Key('save-profile-button')));
    await tester.pumpAndSettle();

    expect(find.text('Ayu Pratama'), findsOneWidget);
    expect(find.text('AP'), findsOneWidget);
  });
}
