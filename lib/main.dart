import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Scientia',
    
    home: LoginScreen(), 
  ));
}