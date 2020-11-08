import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:yello_video_player/animations/delayed_animation.dart';
import 'package:yello_video_player/managers/shared_pref_manager.dart';
import 'package:yello_video_player/models/UserModel.dart';
import 'package:yello_video_player/networking/login.dart';
import 'package:yello_video_player/ui/home_screen.dart';
import 'file:///E:/Coding/Projects/YelloVideoPlayer/yello_video_player/lib/ui/SplashScreen.dart';
import 'package:yello_video_player/utils/CustomIcons.dart';
import 'package:yello_video_player/widgets/SocialIcons.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  bool isIOS = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white
    ));
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    if (Platform.isIOS) {
      this.isIOS = true;
    }

    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 20000), () async {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return SplashScreen();
      }));
    });
  }

  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  List<Widget> getLoginButtons() {
    List<Widget> loginButtons = List<Widget>();
    if (isIOS) {
      loginButtons.add(
        SocialIcon(
          iconData: CustomIcons.apple,
          onPressed: () {
            Toast.show("Apple Login is not available yet.", context);
          },
        ),
      );
    }
    loginButtons.add(
      SocialIcon(
        iconData: CustomIcons.google,
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => Center(
                child: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.amber),
                  ),
                ),
              )
          );
          signInWithGoogle().then((result) async {
            Navigator.pop(context);
            if(result==true){
              SharedPreferences sharedPreferences = await SharedPrefManager.getInstance();
              UserModel user = new UserModel();
              user.email = sharedPreferences.getString(SharedPrefManager.email);
              user.userId = sharedPreferences.getString(SharedPrefManager.userId);
              user.username = sharedPreferences.getString(SharedPrefManager.userName);
              user.userUrl = sharedPreferences.getString(SharedPrefManager.userUrl);
              Toast.show(
                  "Welcome, ${sharedPreferences.getString(SharedPrefManager.userName)}",
                  context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                return HomeScreen(user: user,);
              }));
            }else{
              Toast.show("Something went wrong. Please try again later.", context);
            }
          });
        },
      ),
    );
    loginButtons.add(
      SocialIcon(
        iconData: CustomIcons.facebook,
        onPressed: () {
          Toast.show("Facebook login is not availble yet.", context);
        },
      ),
    );
    return loginButtons;
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Scaffold(
      body: showLoginScreen(),
    );
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.amber));
    }
  }


  Widget showCircularLoader() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.0,
              width: 60.0,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget showLoginScreen() {
    final color = Colors.white;
    return Stack(
      children: [
        //Video Player
        Container(
          height: double.infinity,
          child: Image.asset(
            "assets/images/img_login.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 95,
              ),
              DelayedAnimation(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Welcome\nTo',
                          style: TextStyle(
                            wordSpacing: 1.2,
                            color: Colors.black,
                            fontSize: 30.0,
                          ),
                          children: [
                            TextSpan(
                                text: 'YellowVideoPlayer',
                                style: TextStyle(
                                  wordSpacing: 1.2,
                                  color: Colors.black,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //TODO: do something
                                  })
                          ]),
                    )
                  ],
                ),
                delay: delayedAmount + 1000,
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 130.0,
              ),
              SizedBox(
                height: 250.0,
              ),
              DelayedAnimation(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Login with',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                              color: color),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: getLoginButtons(),
                    )
                  ],
                ),
                delay: delayedAmount + 1500,
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        )
      ],
    );
  }
}
