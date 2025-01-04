import 'dart:collection';

import 'package:expragati/employee_model.dart';
import 'package:expragati/home_screen.dart';
import 'package:expragati/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExPragati',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Something'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getToken();
  }

  var userData = HashMap<String, String>();
  bool isAllowed = false;

  // validate user
  bool validate(HashMap<String, String> data) {
    for (var entry in data.entries) {
      if (entry.value.isEmpty) {
        return false;
      }
    }
    return true;
  }

  // check token
  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    userData["token"] = prefs.getString("token") ?? "";
    userData["name"] = prefs.getString("name") ?? "";
    userData["contact"] = prefs.getString("contact") ?? "";
    userData["role"] = prefs.getString("role") ?? "";
    userData["empid"] = prefs.getString("empid") ?? "";

    if (validate(userData)) {
      isAllowed = true;
    }
    // print("values");
    // userData.forEach((key, value) {
    //   print('$key: $value');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isAllowed
          ? HomeScreen(
              employeeModel: EmployeeModel(
                  employee: Employee(
                      empId: userData["empid"],
                      empName: userData["name"],
                      empNumber: userData["contact"],
                      empDesignation: userData["role"]),
                  token: userData["token"]))
          : const LoginScreen(),
    );
  }
}
