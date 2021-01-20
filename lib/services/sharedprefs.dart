import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs
{
  static String IsLoggedInKey = "IsLoggedIn";
  static String NameKey = "Name";
  static String EmailKey = "Email";

  static Future<bool> saveUserLoggedIn(bool isloggedin) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(IsLoggedInKey, isloggedin);
  }

  static Future<bool> saveUserName(String name) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(NameKey, name);
  }

  static Future<bool> saveEmail(String email) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(EmailKey, email);
  }

  static Future<bool> getUserLoggedIn() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getBool(IsLoggedInKey);
  }

  static Future<String> getName() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(NameKey);
  }

  static Future<String> getEmail() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(EmailKey);
  }

}