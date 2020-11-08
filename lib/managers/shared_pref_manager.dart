
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager{
  static SharedPreferences _sharedPreferences;
  static String email = "EMAIL";
  static String userName = "USERNAME";
  static String userId = "USERID";
  static String userUrl = "USERURL";

  SharedPrefManager._();

  static Future<SharedPreferences> getInstance() async{
    if(_sharedPreferences == null){
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _sharedPreferences;
  }

  void clearUserCache() async{
    SharedPreferences sharedPreferences = await SharedPrefManager.getInstance();
    sharedPreferences.clear();
  }
}