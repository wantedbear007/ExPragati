import 'dart:async';
import 'dart:convert';

import 'package:abc/employee_model.dart';
import 'package:abc/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    Future<void> login_handler() async {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Enter username and password. !")));
        return;

      } else {


      try {

        final String loginEndpoint = dotenv.get("LOGIN");

        final response = await http.post(Uri.parse(loginEndpoint),
            headers: <String, String>{
              'Connection': 'keep-alive',
              'sec-ch-ua': '"Not/A)Brand";v="8", "Chromium";v="126", "Microsoft Edge";v="126", "Microsoft Edge WebView2";v="126"',
              'Accept': 'application/json, text/plain, */*',
              'Content-Type': 'application/json',
              'sec-ch-ua-mobile': '?0',
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0',
              'sec-ch-ua-platform': '"Windows"',
              'Origin': 'https://tauri.localhost',
              'Sec-Fetch-Site': 'cross-site',
              'Sec-Fetch-Mode': 'cors',
              'Sec-Fetch-Dest': 'empty',
              'Referer': 'https://tauri.localhost/',
              'Accept-Language': 'en-GB,en;q=0.9,en-US;q=0.8'
            },
            body: jsonEncode(<String, String> {
              "emp_email": _emailController.text,


              "emp_password": _passwordController.text,
              "medium": "app"
            }));

        final Map<String, dynamic> responseJson = jsonDecode(response.body) as Map<String, dynamic>;


        
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseJson["message"])));
          print(response.body.toString());

          final employeeData = EmployeeModel.fromJson(responseJson);
          // print(formatted.toString());
          // print(formatted.employee?.empGender.toString());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx) => HomeScreen(employeeModel: employeeData,)));
        }

        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseJson["message"])));
        }


      } catch (err) {
        print(err.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Server Error ${err.toString()}")));
      }

      }



      // print(response.body.toString());
      //
      // print("hello");
      // print(_emailController.text);
      // print(_passwordController.text);
      //
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("hello")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.yellow,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage("https://api.multiavatar.com/${Random().nextInt(100)}.png"),
                ),
                SizedBox(height: 20,),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Please login to your account',
                  style: TextStyle(
                    fontSize: 16,
                    // color: Colors.white
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,

                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(

                  // keyboardType: ,
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  // child: Text(
                  //   'Forgot Password?',
                  //   style: TextStyle(
                  //     color: Colors.blue,
                  //   ),
                  // ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      login_handler();

                    },

                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,

                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
