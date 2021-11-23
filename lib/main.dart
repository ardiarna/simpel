import 'package:flutter/material.dart';
import 'package:simpel/chat/composition_root.dart';
import 'package:simpel/utils/af_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: splashRoute,
      routes: afRoutes,
      title: 'Simpel',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
