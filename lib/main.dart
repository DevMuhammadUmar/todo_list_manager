import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_manager/pages/homepage.dart';
import 'providers/todo_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Todo List Manager';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()..initializeAsync(),),
        ChangeNotifierProvider(create: (context) => ThemeProvider(),),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const Homepage(),
          );
        },
      ),
    );
  }

}
