import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/sharedprefs.dart';
import 'signup.dart';
import 'chatrooms.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn>
{
  DatabaseServices ds=new DatabaseServices();
  final mykey=new GlobalKey<ScaffoldState>();
  AuthService _auth= new AuthService();
  String email="",password="";
  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;
  signMein(BuildContext context) async
  {
    if(_formKey.currentState.validate())
      {
        setState(() {
          isLoading=true;
        });
        _auth.signInWithEmailAndPassword(email.trim(), password.trim()).then((value)
        {

          SharedPrefs.saveEmail(email);
          SharedPrefs.saveUserLoggedIn(true);
          

          
          if(value.toString()!="null")
            {
              print("THIS: " + value.toString());
              setState(() {
                isLoading=false;
              });
              ds.getUserFromEmail(email).then((val)
              {
                QuerySnapshot qs=val;
                SharedPrefs.saveUserName(qs.docs[0].data()['Name'].toString());
                SharedPrefs.getName().then((value) {print(value);});
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRooms()));
              });

            }
          else
            {

                  final snackBar = SnackBar(
                  content: Text('Invalid user credentials'),
                  action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {

                  },
                  ),
                  );
                  setState(() {
                    isLoading=false;
                  });
                  mykey.currentState.showSnackBar(snackBar);
            }
          print("$value");

        });
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.blue[400],appBar: AppBar(elevation: 0.0,backgroundColor: Colors.transparent,), key: mykey,
      resizeToAvoidBottomInset: false,
      body: isLoading? Container(child: Center(child: CircularProgressIndicator(),),):Form(key: _formKey,
        child: Container(
          child: Column(
            children: [
              Container(alignment: Alignment.center,child: Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w600),)),
              SizedBox(height: 60),
              Container(padding: EdgeInsets.symmetric(horizontal: 50),alignment: Alignment.centerLeft,child: Text("Email",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              SizedBox(height: 0),
              Container(decoration: BoxDecoration(color: Colors.blue[300],),margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),child: TextFormField( decoration: InputDecoration(fillColor:Colors.red,enabledBorder: InputBorder.none,prefixIcon: Icon(Icons.email,color: Colors.white,), hintText: "Enter your email",hintStyle: TextStyle(color: Colors.white70,fontSize: 15)),
                validator: (val){return val.isEmpty?"Enter a valid email":null;},onChanged: (val){email=val;}
                ,)),
              SizedBox(height: 10,),
              Container(padding: EdgeInsets.symmetric(horizontal: 50),alignment: Alignment.centerLeft,child: Text("Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)),
              SizedBox(height: 0),
              Container(decoration: BoxDecoration(color: Colors.blue[300],),margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),child: TextFormField(obscureText: true,decoration: InputDecoration(fillColor:Colors.red,enabledBorder: InputBorder.none,prefixIcon: Icon(Icons.vpn_key,color: Colors.white,), hintText: "Enter your password",hintStyle: TextStyle(color: Colors.white70,fontSize: 15)),
                validator: (val){return val.isEmpty?"Enter a valid password":null;},onChanged: (val){password=val;},)),
              Row(
                children: [
                  Spacer(),
                  InkWell(onTap:()
                  {
                    _auth.resetPass(email).then((value)
                    {

                      if(email.isNotEmpty)
                      {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Please click the link send to your email to reset password'),
                              action: SnackBarAction(onPressed: () {},
                                label: 'Ok',));

                          //final snackBar = SnackBar(content: Text('Please click the link send to your email to reset password'));
                          mykey.currentState.showSnackBar(snackBar);
                      }
                      else
                        {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Enter a valid email ID to reset password.'),
                              action: SnackBarAction(onPressed: () {},
                                label: 'Ok',));

                          mykey.currentState.showSnackBar(snackBar);
                        }
                    });


                  },child: Container(margin: EdgeInsets.only(right: 50),alignment: Alignment.centerLeft,child: Text("Forgot password?",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),))),
                ],
              ),
              SizedBox(height: 70,),
              InkWell(onTap:(){signMein(context);},child: ClipRRect(borderRadius: BorderRadius.circular(30),child: Container(color: Colors.white,child: Text("Login",style: TextStyle(color:Colors.blue[700],fontSize: 18),),padding: EdgeInsets.symmetric(vertical: 15,horizontal: 120),))),
              SizedBox(height: 30,),
              Spacer(),
              Container(padding: EdgeInsets.symmetric(vertical: 25),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Don't have an account? ",style: TextStyle(color: Colors.white,fontSize: 17),),
                  InkWell(onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));},child: Text("Sign up",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),
                ],),
              )
          ],),

        ),
      ),);
  }
}
