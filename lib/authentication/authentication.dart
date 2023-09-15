import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_one_epub/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_one_epub/constants/constants.dart';

class AuthenticationController extends GetxController{
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

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
    required String userName,
    required String password,
  }) async {
    try{
      isLoading.value = true;
      var data = {
        'username': userName,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${siteUrl}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

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