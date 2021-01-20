import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/signin.dart';
import 'package:my_chat_app/services/constants.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/sharedprefs.dart';
import 'search.dart';
import 'package:my_chat_app/services/auth.dart';
import 'dart:async';
import 'chat_conversation.dart';
class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {

  String username;
  Stream rooms=null;
  DatabaseServices _dbs= new DatabaseServices();

  Widget UserTiles(String username, String name)
  {
    String chatid=getChatRoomID(username, name);
    return FutureBuilder(future: _dbs.getLastMessages(chatid),builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot)
    {
      if (snapshot.connectionState == ConnectionState.done)
      {
        return Text(snapshot.data["message"]);
      }
      else return Container();
    });





  }

  Widget Rooms()
  {
    return rooms==null?Container(child: Text("Error1"),):StreamBuilder(stream: rooms, builder: (context, snapshot)
    {
      return snapshot==null?Container(child: Text("Error2"),):ListView.builder(itemCount: snapshot.data.docs.length,itemBuilder: (context, index)
      {
        print("YEA"+snapshot.data.docs.length.toString());
        List<dynamic> users=snapshot.data.docs[index].get('users');

        return users[0]==username? UserTile(users[1], username):UserTile(users[0], username);
      });
    });
  }

  @override
  void initState()
  {
    SharedPrefs.getName().then((value)
    {
      Constants.name=value;
      username=value;
      print("CALLEDXD "+Constants.name);
      _dbs.getChatRoomsFromName(value).then((val)
      {
        setState(()
        {
          rooms=val;
          print(rooms);
        });
      });
    });
    super.initState();
  }


  AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(iconTheme:IconThemeData(color: Colors.black54,),backgroundColor: Colors.transparent,elevation:0.0,title: Row(children: [
      Spacer(),
      Text("   We",style: TextStyle(fontSize: 24,color: Colors.black54),),
      Text("Connect",style: TextStyle(fontSize:25,color: Colors.blue,fontWeight: FontWeight.bold)),
      Spacer(),
      IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
        _auth.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
        SharedPrefs.saveUserLoggedIn(false);
      },)
    ],),),floatingActionButton: FloatingActionButton(child: Icon(Icons.search),onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
    },),body: Container(padding:EdgeInsets.only(top: 10),child: Rooms()),

    );
  }
}

class UserTile extends StatelessWidget
{

  DatabaseServices _dbs=new DatabaseServices();
  String name='s', user='s',chatid="", lastMsg="ss";

  UserTile(String name, String user)
  {
    this.user=user;
    this.name=name;
    chatid=getChatRoomID(name, user);

  }

  @override
  Widget build(BuildContext context)
  {

    return Container(child: Container(margin: EdgeInsets.only(bottom: 10), padding: EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Text(name,style: TextStyle(fontSize: 20),),
          Spacer(),
          InkWell(onTap: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatConversation(chatroomid: chatid,friendname: name,)));
          },
              child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),decoration:BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.blue),child: Text("Message",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white,fontSize: 15),),))
        ],
      ),
    ),);
  }
}


getChatRoomID(String a, String b)
{
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0))
  {
    return "$b\_$a";
  }
  else return "$a\_$b";
}