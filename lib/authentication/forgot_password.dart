import 'package:flutter/material.dart';
import 'package:flutter_one_epub/authentication/widgets/input_widget.dart';
import 'package:flutter_one_epub/authentication/authentication.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _securityNumberController = TextEditingController();
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());

  bool emailsent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Forgot password page', style: TextStyle(fontSize: 25.0),),
              const SizedBox(height: 30.0,),
              InputWidget(hintText: 'Email', controller: _emailController, obscureText: false),
              const SizedBox(height: 20.0,),

              Visibility(
                visible: emailsent,
                child: Column(
                  children: [
                    
                    InputWidget(hintText: 'New password', controller: _newPasswordController, obscureText: true),

                    const SizedBox(height: 20.0,),
                    InputWidget(hintText: 'Confirm password', controller: _confirmPasswordController, obscureText: true), 

                    const SizedBox(height: 20.0,),
                    const Text("Please check your email, we sent the security number"),
                    InputWidget(hintText: 'Security number', controller: _securityNumberController, obscureText: false), 
                    const SizedBox(height: 20.0,),
                  ],
                )
              ),
              
              Visibility(
                visible: emailsent,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    await _authenticationController.change_password(
                      email: _emailController.text.trim(),
                      password: _newPasswordController.text.trim(),
                      password_confirmation: _confirmPasswordController.text.trim(),
                      security_number: _securityNumberController.text.trim(),
                    );
                  }, 
                  child: Obx(() {
                    return _authenticationController.isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('Change password', style: TextStyle(fontSize: 18),);
                  }),
                ),
              ),
                          
              
              Visibility(
                visible: !emailsent,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    await _authenticationController.forgot_password(
                      email: _emailController.text.trim(),
                    );
                    await _checkSentEmail();
                  }, 
                  child: Obx(() {
                    return _authenticationController.isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('Send', style: TextStyle(fontSize: 18),);
                  }),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  _checkSentEmail() async
  {
    emailsent = _authenticationController.emailsent.value;
    setState(() {
        emailsent = emailsent;  
      });  
  }
}