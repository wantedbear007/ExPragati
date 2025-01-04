import 'dart:async';
import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expragati/employee_model.dart';
import 'package:expragati/home_screen.dart';
import 'package:expragati/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// const String bg = '''<svg xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:svgjs="http://svgjs.dev/svgjs" viewBox="0 0 800 800"><defs><filter id="bbblurry-filter" x="-100%" y="-100%" width="400%" height="400%" filterUnits="objectBoundingBox" primitiveUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
// 	<feGaussianBlur stdDeviation="40" x="0%" y="0%" width="100%" height="100%" in="SourceGraphic" edgeMode="none" result="blur"></feGaussianBlur></filter></defs><g filter="url(#bbblurry-filter)"><ellipse rx="150" ry="150" cx="333.18494402338234" cy="158.77062997907547" fill="hsl(37, 99%, 67%)"></ellipse><ellipse rx="150" ry="150" cx="445.59942213782654" cy="595.10320794104" fill="hsl(316, 73%, 52%)"></ellipse><ellipse rx="150" ry="150" cx="636.2167310124642" cy="163.1432691363295" fill="hsl(185, 100%, 57%)"></ellipse></g></svg>''';
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _welcomeMessage = 'Welcome, Login to your account';
  late Timer _timer;
  int _currentLanguageIndex = 0;


  bool isRequestInProgress = false;


  final List<String> _welcomeMessages = [
    'Welcome', // English
    'स्वागत हैं', // Hindi
    'ਸਵਾਗਤ ਹੈ', // Punjabi
  ];

  String avatarUrl = "";

  @override
  void initState() {
    super.initState();


    avatarUrl = "https://api.multiavatar.com/${Random().nextInt(100)}.png";

    // 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _welcomeMessage = _welcomeMessages[_currentLanguageIndex];
        _currentLanguageIndex =
            (_currentLanguageIndex + 1) % _welcomeMessages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> login_handler() async {
    if (isRequestInProgress) {
      return;
    }

    if (_emailController.text
        .trim()
        .isEmpty ||
        _passwordController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter username and password. !")));
      return;
    } else {
      try {
        setState(() {
          isRequestInProgress = true;
        });

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
            body: jsonEncode(<String, String>{
              "emp_email": _emailController.text,
              "emp_password": _passwordController.text,
              "medium": "app"
            }));

        final Map<String, dynamic> responseJson = jsonDecode(
            response.body) as Map<String, dynamic>;

        setState(() {
          isRequestInProgress = false;
        });



        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseJson["message"])));
          // print(response.body.toString());

          final employeeData = EmployeeModel.fromJson(responseJson);
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString("token", employeeData.token!);
          await prefs.setString("name", employeeData.employee!.empName ?? "NA");
          await prefs.setString("contact", employeeData.employee!.empNumber ?? "NA");
          await prefs.setString("role", employeeData.employee!.empDesignation ?? "NA");
          await prefs.setString("empid", employeeData.employee!.empId ?? "NA");

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext ctx) =>
                  HomeScreen(employeeModel: employeeData,)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseJson["message"])));
        }
      } catch (err) {
        setState(() {
          isRequestInProgress = false;
        });
        // print(err.toString());
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Server Error ${err.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Blur(
              blurColor: Colors.black,
              blur: 25.0,
              child: SvgPicture.string(
                loginScreenSVG,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        imageBuilder: (context, imageProvider) =>
                            CircleAvatar(
                              radius: 120,
                              backgroundImage: imageProvider,
                            ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'ExPragati',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _welcomeMessage,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Colors.white60),
                        filled: true,
                        suffixIcon: Icon(Icons.abc),
                        fillColor: Colors.black38,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.hide_source,
                            color: Colors.white60),
                        filled: true,
                        suffixIcon: Icon(Icons.password),
                        fillColor: Colors.black38,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                     SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          login_handler();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.white60,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //
          //   bottom: 30,
          //   left: 0,
          //   right: 0,
          //   child: Text(
          //     "</> with ❤️ by Wantedbear007",
          //     textAlign: TextAlign.center,
          //     style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
    );
  }
}