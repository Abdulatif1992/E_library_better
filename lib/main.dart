import 'package:flutter/material.dart';
import 'package:flutter_one_epub/authentication/login_page.dart';
import 'package:flutter_one_epub/home_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: HomeScrenn()
      //home: LoginPage()
    );
  }
}
