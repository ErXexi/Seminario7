// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/screens/screens.dart';
import 'package:seminariovalidacion/screens/signup_screen.dart';
import 'package:seminariovalidacion/services/services.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductsService())],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        '/': (_) => LoginScreen(),
        'login':(_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'signup': (_) => SignUpScreen(),
        'registrar': (_) => RegisterScreen(),
        'product': (_) => ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo,
        ),
      ),
    );
  }
}
