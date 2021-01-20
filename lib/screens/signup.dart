import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/chatrooms.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/sharedprefs.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>
{
  String name="",email="",password="";
  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;
  AuthService _auth = new AuthService();
  DatabaseServices _dbs = new DatabaseServices();
  SignMeUp() async
  {
    if(_formKey.currentState.validate())
    {
      setState(() {
        isLoading=true;
      });
      await _auth.signUpWithEmailAndPassword(email, password).then((value)
      {
        if(value!=null)
        {
          setState(() {
            isLoading=false;
          });
          SharedPrefs.saveUserLoggedIn(true);
          SharedPrefs.saveEmail(email);
          SharedPrefs.saveUserName(name);
          Map<String, String> userMap =
          {
            "Name":name,
            "Email":email,
          };
          _dbs.uploadUserInfo(userMap);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRooms()));
        }
        print("$value");
        setState(() {
          isLoading=false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.blue[400],appBar: AppBar(elevation: 0.0,backgroundColor: Colors.transparent,),
      resizeToAvoidBottomInset: false,
      body: isLoading? Container(child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),),): Form(key: _formKey,
        child: Container(
          child: Column(
            children: [
              Container(alignment: Alignment.center,child: Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w600),)),
              SizedBox(height: 60),
              Container(padding: EdgeInsets.symmetric(horizontal: 50),alignment: Alignment.centerLeft,child: Text("Username",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              SizedBox(height: 10),
              Container(decoration: BoxDecoration(color: Colors.blue[300],),margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),child: TextFormField( decoration: InputDecoration(fillColor:Colors.red,enabledBorder: InputBorder.none,prefixIcon: Icon(Icons.person,color: Colors.white,), hintText: "Enter a username",hintStyle: TextStyle(color: Colors.white70,fontSize: 15)),
                validator: (val){return val.isEmpty?"Enter a valid username":null;},onChanged: (val){name=val;}
                ,)),

              Container(padding: EdgeInsets.symmetric(horizontal: 50),alignment: Alignment.centerLeft,child: Text("Email",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              SizedBox(height: 10),
              Container(decoration: BoxDecoration(color: Colors.blue[300],),margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),child: TextFormField( decoration: InputDecoration(fillColor:Colors.red,enabledBorder: InputBorder.none,prefixIcon: Icon(Icons.email,color: Colors.white,), hintText: "Enter your email",hintStyle: TextStyle(color: Colors.white70,fontSize: 15)),
                validator: (val){return val.isEmpty?"Enter a valid email":null;},onChanged: (val){email=val;}
                ,)),
              SizedBox(height: 10,),
              Container(padding: EdgeInsets.symmetric(horizontal: 50),alignment: Alignment.centerLeft,child: Text("Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)),
              SizedBox(height: 0),
              Container(decoration: BoxDecoration(color: Colors.blue[300],),margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),child: TextFormField(obscureText: true,decoration: InputDecoration(fillColor:Colors.red,enabledBorder: InputBorder.none,prefixIcon: Icon(Icons.vpn_key,color: Colors.white,), hintText: "Enter your password",hintStyle: TextStyle(color: Colors.white70,fontSize: 15)),
                validator: (val){return val.length < 6?"Passwords must have at least 6 characters.":null;},onChanged: (val){password=val;},
              )),

              SizedBox(height: 70,),
              InkWell(onTap:(){SignMeUp();},child: ClipRRect(borderRadius: BorderRadius.circular(30),child: Container(color: Colors.white,child: Text("Sign Up",style: TextStyle(color:Colors.blue[700],fontSize: 18),),padding: EdgeInsets.symmetric(vertical: 15,horizontal: 120),))),
              SizedBox(height: 25,),
              Spacer(),
              Container(padding: EdgeInsets.symmetric(vertical: 25),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",style: TextStyle(color: Colors.white,fontSize: 17),),
                    InkWell(onTap:(){Navigator.pop(context);},child: Text("Sign in",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),
                  ],),
              )
            ],),

        ),
      ),);
  }
}
