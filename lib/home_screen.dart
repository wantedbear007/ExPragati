import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:expragati/employee_model.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:expragati/login_screen.dart';
import 'package:expragati/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




enum PunchState {
  punchIn,
  punchOut
}


class HomeScreen extends StatelessWidget {

  final EmployeeModel employeeModel;

  HomeScreen({super.key, required this.employeeModel});




  final Map<String, dynamic> employee = {
    "emp_username": "Bhanup",
    "emp_name": "Bhanupratap Singh",
    "emp_image": "assets/images/lg/avatar5.jpg",
    "emp_work_dept": "Tech Department",
    "emp_designation": "Blockchain Developer",
  };

  String avatarUrl = "";




  @override
  Widget build(BuildContext context) {
    punchIn(String punchState) async {
      try {
        final String punchEndpoint = dotenv.get("PUNCH");


        DateTime now = DateTime.now().toUtc();


        final response = await http.post(Uri.parse(punchEndpoint),
          headers: <String, String>{
            'Connection': 'keep-alive',
            'sec-ch-ua': '"Not/A)Brand";v="8", "Chromium";v="126", "Microsoft Edge";v="126", "Microsoft Edge WebView2";v="126"',
            'Accept': 'application/json, text/plain, */*',
            'Content-Type': 'application/json',
            'sec-ch-ua-mobile': '?0',
            'Authorization': employeeModel.token!,
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0',
            'sec-ch-ua-platform': '"Windows"',
            'Origin': 'https://tauri.localhost',
            'Sec-Fetch-Site': 'cross-site',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Dest': 'empty',
            'Referer': 'https://tauri.localhost/',
            'Accept-Language': 'en-GB,en;q=0.9,en-US;q=0.8'
          },



          body: jsonEncode(<String, dynamic> {
            "verify": {
              "emp_id": employeeModel.employee!.empId,
              "medium": "app"
            },
            "data": {
              "emp_id": employeeModel.employee!.empId,
              "punch_time": now.toIso8601String(),
              // "punch_type": "out",
              "punch_type": punchState,
              "punch_from": "office"
            }
          })

        );

        var decodedBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          if (decodedBody["status"] == "success") {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(

                title: 'Congratulations',
                message:
                decodedBody["message"],

                contentType: ContentType.success,
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          } else {
            final snackBar = SnackBar(
              elevation: 0,

              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(

                title: 'Oops',
                message:
                decodedBody["message"],

                contentType: ContentType.failure,
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        } else {
          print(response.body.toString());
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Authentication failed, try again")));
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext ctx) =>
                  LoginScreen()));
        }

        // print(response.statusCode);
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
        print("error ${err.toString()}");
      }


    }

    // print(employeeModel.employee?.empEmail.toString());
    // print(employeeModel.employee?.empImage.toString());

    final employeeData = employeeModel.employee!;

    return Scaffold(
      backgroundColor: Colors.black,
      body:Stack(
        children: [

          Positioned.fill(
            child: Blur(
              blurColor: Colors.black,
              blur: 25.0,
              child: SvgPicture.string(
                homeScreenSVG,
                fit: BoxFit.cover,
              ),
            ),
          ),

      Center(
        child: Padding(

          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage("https://api.multiavatar.com/${employeeData.empName}.png"),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Welcome Back,',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,

                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                employeeData.empName ?? "NA",
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 10),

              Text(
                // employee["emp_designation"],
    "Contact: " + (employeeData.empNumber ?? "NA"),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              // SizedBox(height: 10),
              Text(
                // employee["emp_designation"],
                "Role: " + (employeeData.empDesignation ?? "NA"),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              // Text(
              //   employeeData.empWorkDept ?? "NA",
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.white70,
              //   ),
              // ),
              SizedBox(height: 10,),
              SizedBox(
                // width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("token");
                    await prefs.remove("name");
                    await prefs.remove("contact");
                    await prefs.remove("role");
                    await prefs.remove("empid");
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            LoginScreen()));
                  },
                  child: Text('Logout', style: TextStyle(color: Colors.white,),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    // primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // MaterialButton(onPressed: () async {
              //   final prefs = await SharedPreferences.getInstance();
              //   String res = prefs.getString("token")!;
              //   print("all the values: " + res);
              // }, child: Text("helllo", style: TextStyle(fontSize: 30, color: Colors.white),),),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: ElevatedButton(

                  onPressed: () async {
                    await punchIn("in");
                    // Add punch in logic
                  },
                  child: Text('Punch Attendance ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.green),),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    // backgroundColor: Colors.green,
                    backgroundColor: Colors.white24,
                    // side: BorderSide(
                    //   color: Colors.green,
                    //   width: 1.5,
                    // ),
                    // primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(50),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                      

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () async {
                    await punchIn("out");
                  },
                  child: Text('Punch Out ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),),

                  // child: Text('Punch Out 🏕️', style: TextStyle(color: Colors.white,),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    // side: BorderSide(
                    //
                    //   color: Colors.red,
                    //   width: 1.5,
                    // ),
                    // primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(30),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                      
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
          Positioned(

            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              "</> with ❤️ by Wantedbear007",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )
    );
  }
}