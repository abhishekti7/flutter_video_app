
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yello_video_player/managers/shared_pref_manager.dart';

class UserModel{
  String username;
  String userId;
  String email;
  String userUrl;
  UserModel();

  void storeInCache() async{
    SharedPreferences sharedPreferences = await SharedPrefManager.getInstance();
    sharedPreferences.setString(SharedPrefManager.email, this.email);
    sharedPreferences.setString(SharedPrefManager.userName, this.username);
    sharedPreferences.setString(SharedPrefManager.userId, this.userId);
    sharedPreferences.setString(SharedPrefManager.userUrl, this.userUrl);
  }

  Future<UserModel> getUser() async{
    SharedPreferences sharedPreferences = await SharedPrefManager.getInstance();
    UserModel user = UserModel();
    user.userId = sharedPreferences.getString(SharedPrefManager.userId);
    user.email = sharedPreferences.getString(SharedPrefManager.email);
    user.username = sharedPreferences.getString(SharedPrefManager.userName);
    user.userUrl = sharedPreferences.getString(SharedPrefManager.userUrl);
    return user;
  }
}