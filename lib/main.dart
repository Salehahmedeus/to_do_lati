import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_lati/providers/tasks_provider.dart';
import 'package:to_do_lati/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO App',
      home: HomeScreen(),
    );
  }
}
