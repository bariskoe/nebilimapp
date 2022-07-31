// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:nebilimapp/pages/single_quiz_page.dart';

// import 'package:nebilimapp/dependency_injection.dart' as di;
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   Map<String, Object> values = <String, Object>{
//     'numberOfQuestionsInDatabase': 1
//   };
//   SharedPreferences.setMockInitialValues(values);
//   WidgetsFlutterBinding.ensureInitialized();
//   await di.setupDependencyInjectionWithGetIt();
//   testWidgets('finds a widget using a Key', (tester) async {
//     // Define the test key.
//     const testKey = Key('playButton');

//     // Build a MaterialApp with the testKey.
//     await tester.pumpWidget(MaterialApp(key: testKey, home: SingleQuizPage()));

//     // Find the MaterialApp widget using the testKey.
//     expect(find.byKey(testKey), findsOneWidget);
//   });
// }
