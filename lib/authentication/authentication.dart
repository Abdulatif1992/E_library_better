import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_one_epub/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_one_epub/constants/constants.dart';

class AuthenticationController extends GetxController{
  final isLoading = false.obs;
  final emailsent = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  Future forgot_password({
    required String email,
  }) async {
    try{
      isLoading.value = true;
      emailsent.value = false;
      var data = {
        'email': email,
      };

      var response = await http.post(
        Uri.parse('${siteUrl}sendemail'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      if(response.statusCode ==200){
        isLoading.value = false;
        emailsent.value = true; 
        //Get.offAll(() => const HomeScrenn());
      }
      else{
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    }catch (e) {
      print(e.toString());
    }
  }

  Future change_password({
    required String email,
    required String password,
    required String password_confirmation,
    required String security_number,
  }) async {
    try{
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
        'security_number': security_number,
      };

      var response = await http.post(
        Uri.parse('${siteUrl}change_password'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if(response.statusCode == 201){
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const HomeScrenn());
      }
      else{
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      print(e.toString());
    }
  }
  
  Future register({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async{
    try{
      isLoading.value = true;
      var data = {
        'name': name,
        'username': userName,
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${siteUrl}register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if(response.statusCode == 201){
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const HomeScrenn());
      }
      else{
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      print(e.toString());
    }
  }

  Future login({
    required String email,
    required String password,
  }) async {
    try{
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${siteUrl}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      print(response.statusCode);
      print(response.body);
      if(response.statusCode ==200){
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const HomeScrenn());
      }
      else{
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}