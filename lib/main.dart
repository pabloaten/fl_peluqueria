import 'package:fl_peluqueria/screens/home_screen.dart';
import 'package:fl_peluqueria/screens/horario_peluqueros_screen.dart';
import 'package:fl_peluqueria/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_peluqueria/screens/register_screen.dart';
import 'package:fl_peluqueria/app_theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA3nna1HOGWHDWNe1nefkosODc8CGxMoKw",
    authDomain: "fl-productos2023-2024.firebaseapp.com",
    databaseURL: "https://fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app",
    projectId: "fl-productos2023-2024",
    storageBucket: "fl-productos2023-2024.appspot.com",
    messagingSenderId: "76139869605",
    appId: "1:76139869605:web:bc305d402cb68c7ac1a44c",
    measurementId: "G-YJG8D4XX75"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HorarioPeluquerosScreen(),
       theme: AppTheme.lightTheme,
    );
  }
}
