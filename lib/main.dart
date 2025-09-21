import 'package:examen_flutter/app/modules/login/views/login_view.dart';
import 'package:examen_flutter/app/modules/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Management',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Inter',
      ),
      home: LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  Get.put(ApiService());
  runApp(MyApp());
}