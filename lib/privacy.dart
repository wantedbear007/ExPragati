import 'package:blur/blur.dart';
import 'package:expragati/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: const Text('Privacy & Disclaimer', style: TextStyle(color: Colors.white60),),
        leading: MaterialButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Icon(Icons.arrow_back_ios, color: Colors.white60,),),
      ),
      
      body: Stack(children: [
    //   Positioned.fill(
    //   child: Blur(
    //   blurColor: Colors.black,
    //     blur: 25.0,
    //     child: SvgPicture.string(
    //       loginScreenSVG,
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    // )

        Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              'Disclaimer:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white60
              ),
            ),
            SizedBox(height: 10),
            Text(
                'Expragati is a fork of PragatiHRM and is in no way affiliated with the original developers. All actions and usage performed on Expragati are solely at the users own discretion and may result in immediate termination of access without prior notice.',
            style: TextStyle(fontSize: 16,color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            'Expragati should only be used when PragatiHRM is not compatible with operating systems, such as iOS, Android, or certain Linux distributions (e.g., Fedora), and is not intended for use on other platforms.',
            style: TextStyle(fontSize: 16,color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            'Other than that, you should prefer and use the original PragatiHRM for better stability and support.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            'Users are solely responsible for ensuring compatibility and proper operation on their devices. The developers do not assume any responsibility for any data loss, system failure, or other issues that may arise during the use of this application.',
            style: TextStyle(fontSize: 16,color: Colors.white70),
          ),

              SizedBox(height: 30),
              Text(
                'Team Wantedbear007',
                style: TextStyle(fontSize: 16,color: Colors.white70),
              ),
          ],
        ),
      ),
    ),],)
    );
  }
}
