import 'package:flutter/material.dart';
import 'package:flutter_one_epub/authentication/authentication.dart';
import 'package:flutter_one_epub/authentication/register_page.dart';
import 'package:flutter_one_epub/authentication/widgets/input_widget.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login page', style: TextStyle(fontSize: 25.0),),
              const SizedBox(height: 30.0,),
              InputWidget(hintText: 'Username', controller: _userNameController, obscureText: false),
              const SizedBox(height: 20.0,),
              InputWidget(hintText: 'Password', controller: _passwordController, obscureText: true),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  elevation: 0,
                ),
                onPressed: () async {
                  await _authenticationController.login(
                    userName: _userNameController.text.trim(), 
                    password: _passwordController.text.trim(),
                  );
                }, 
                child: Obx(() {
                  return _authenticationController.isLoading.value
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text('Login', style: TextStyle(fontSize: 18),);
                }),
              ),
              const SizedBox(height: 20.0,),
              TextButton(
                onPressed: () {
                  Get.to(() => const RegisterPage());
                }, 
                child: Text('Register', style: TextStyle(fontSize: 16),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}