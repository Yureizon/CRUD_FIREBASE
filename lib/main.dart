import 'package:crud_firebase/providers/actual_option_provider.dart';
import 'package:crud_firebase/screens/home_screen.dart';
import 'package:crud_firebase/services/students_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActualOptionProvider()),
        ChangeNotifierProvider(create: (_) => StudentsService()),
      ],
      child: MaterialApp (
        debugShowCheckedModeBanner: false,
        initialRoute: 'main',
        routes: {
          'main' : (_) => const HomeScreen(),
        },
      ),
    );
  }
}
