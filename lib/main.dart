import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'file:///E:/Coding/Projects/YelloVideoPlayer/yello_video_player/lib/ui/SplashScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "YellowVideoPlayer",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      home: SplashScreen(),
    );
  }
}
