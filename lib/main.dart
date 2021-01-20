import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/chatrooms.dart';
import 'package:my_chat_app/services/sharedprefs.dart';
import 'screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isloggedin=false;
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SharedPreferences.setMockInitialValues({});
  SharedPrefs.getUserLoggedIn().then((value)
  {
    isloggedin=value;
    print(value);
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    if(isloggedin==null) isloggedin=false;
    return MaterialApp(title: "Chat App", theme: ThemeData(primarySwatch: Colors.blue),
      home: isloggedin?ChatRooms():SignIn(),
    );
  }
}
