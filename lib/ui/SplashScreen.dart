import 'dart:async';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:yello_video_player/managers/shared_pref_manager.dart';
import 'file:///E:/Coding/Projects/YelloVideoPlayer/yello_video_player/lib/ui/login_screen.dart';
import 'package:yello_video_player/models/UserModel.dart';
import 'package:yello_video_player/ui/camera_screen.dart';
import 'package:yello_video_player/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadTimer();
  }

  _loadTimer() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    final user = _auth.currentUser;
    if (user == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen();
      }));
    } else {
      SharedPreferences sharedPreferences = await SharedPrefManager.getInstance();
      UserModel user = new UserModel();
      user.email = sharedPreferences.getString(SharedPrefManager.email);
      user.userId = sharedPreferences.getString(SharedPrefManager.userId);
      user.username = sharedPreferences.getString(SharedPrefManager.userName);
      user.userUrl = sharedPreferences.getString(SharedPrefManager.userUrl);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen(user: user,);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/lottie_camera.json',
                      height: 120.0, width: 120.0, repeat: false),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 12.0, color: Colors.black),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
