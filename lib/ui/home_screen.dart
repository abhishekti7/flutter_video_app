import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:yello_video_player/managers/shared_pref_manager.dart';
import 'package:yello_video_player/models/UserModel.dart';
import 'package:yello_video_player/networking/login.dart';
import 'package:yello_video_player/ui/login_screen.dart';
import 'package:yello_video_player/ui/video_player_screen.dart';
import 'package:yello_video_player/utils/chewie_list_item.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:yello_video_player/widgets/resuable_card.dart';

class HomeScreen extends StatefulWidget {

  final UserModel user;

  HomeScreen({@required this.user, Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username;
  String _email;
  String _photoUrl;
  int volume = 50;

  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;

  @override
  void initState() {
    super.initState();
    _showWelcomeMessage();
    _getProfile();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    CameraDescription firstCamera;
    if(cameras.length > 1){
      firstCamera = cameras[1];
    }else{
      firstCamera = cameras.first;
    }
    _controller = CameraController(firstCamera,ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  void _getProfile() {
    _username = widget.user.username;
    _email = widget.user.email;
    _photoUrl = widget.user.userUrl;
  }

  void _showWelcomeMessage() async {
    SharedPreferences sharedPreferences = await SharedPrefManager.getInstance();
    String name = sharedPreferences.getString(SharedPrefManager.userName);
    Toast.show("Welcome, $name !", context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.amber
    ));
    return Scaffold(
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.amber),
              clipper: getClipper(),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            image: DecorationImage(
                                image: NetworkImage(
                                    _photoUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(
                                Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 90.0),
                    Text(
                      _username,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      _email,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () async{
                              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return VideoPlayerScreen(
                                    videoPlayerController: VideoPlayerController.network('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
                                    looping: false,
                                );
                              }));
                              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.amber));
                            },
                            child: Center(
                              child: Text(
                                'Start Video',
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.redAccent,
                          color: Colors.red,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () async {
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
                              signOutGoogle()
                                  .then((value) {
                                    Navigator.pop(context);
                                Toast.show("Successfully signed out.", context);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return LoginScreen();
                                        }));
                              })
                                  .catchError((err) {
                                print(err);
                                Toast.show(
                                    "Something went wrong! Please try again later.",
                                    context);
                              });
                            },
                            child: Center(
                              child: Text(
                                'Log out',
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }


// this is the future function called to show dialog for confirm exit.
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirm Exit?',
            style: new TextStyle(color: Colors.black, fontSize: 20.0)),
        content: new Text(
            'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              // this line exits the app.
              SystemChannels.platform
                  .invokeMethod('SystemNavigator.pop');
            },
            child:
            new Text('Yes', style: new TextStyle(fontSize: 18.0)),
          ),
          new FlatButton(
            onPressed: () => Navigator.pop(context), // this line dismisses the dialog
            child: new Text('No', style: new TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    ) ??
        false;
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}