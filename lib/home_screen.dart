import 'dart:convert';

import 'package:abc/employee_model.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;




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
        }

        print(response.body.toString());
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
        print("error ${err.toString()}");
      }


    }

    // print(employeeModel.employee?.empEmail.toString());
    // print(employeeModel.employee?.empImage.toString());

    final employeeData = employeeModel.employee!;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage("https://api.multiavatar.com/${employeeData.empName}.png"),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Welcome Back,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,

                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                employeeData.empName ?? "NA",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              Text(
                // employee["emp_designation"],
                employeeData.empEmail ?? "NA",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 10),
              Text(
                // employee["emp_designation"],
                employeeData.empDesignation ?? "NA",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Text(
                employeeData.empWorkDept ?? "NA",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 120,
                child: ElevatedButton(
                  onPressed: () async {
                    await punchIn("in");
                    // Add punch in logic
                  },
                  child: Text('Punch In 🚀', style: TextStyle(fontSize: 20),),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    // primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    await punchIn("out");
                    // final snackBar = SnackBar(
                    //   /// need to set following properties for best effect of awesome_snackbar_content
                    //   elevation: 0,
                    //
                    //   behavior: SnackBarBehavior.floating,
                    //   backgroundColor: Colors.transparent,
                    //   content: AwesomeSnackbarContent(
                    //
                    //     title: 'On Snap!',
                    //     message:
                    //     'This is an example error message that will be shown in the body of snackbar!',
                    //
                    //     /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    //     contentType: ContentType.failure,
                    //   ),
                    // );
                    //
                    // ScaffoldMessenger.of(context)
                    //   ..hideCurrentSnackBar()
                    //   ..showSnackBar(snackBar);
                    // Add punch out logic
                  },
                  child: Text('Punch Out 🏕️', style: TextStyle(color: Colors.white,),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    // primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}