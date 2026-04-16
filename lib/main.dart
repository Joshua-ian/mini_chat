import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minichat/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MiniApp());
}

class MiniApp extends StatelessWidget {
  const MiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MiniChat',
      home: Welcome(),
    );
  }
}