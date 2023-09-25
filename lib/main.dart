import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:offline_form/app/app.dart' show App;
import 'package:offline_form/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
