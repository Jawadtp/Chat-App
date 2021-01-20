import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/services/constants.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/sharedprefs.dart';
import 'chat_conversation.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseServices _dbs=new DatabaseServices();
  String username="";
  QuerySnapshot qs;



  Widget searchList()
  {

    return qs==null?Container():ListView.builder(scrollDirection:Axis.vertical,shrinkWrap:true,itemCount: qs.docs.length,itemBuilder: (context, index){
      return qs.docs[index].get("Name")!=Constants.name?SearchTile(username: qs.docs[index].get("Name"), email: qs.docs[index].get("Email"),context: context,):Container();
    });
  }
  searchInitiate(int x) async
  {
    await _dbs.getUserfromUserName(username.trim(),x).then((val){

      setState(() {
        qs=val;
        print(qs);
      });


    });
  }

  @override
  void initState() {
    searchInitiate(0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(iconTheme:IconThemeData(color: Colors.black54),backgroundColor: Colors.transparent,elevation: 0.0, title: Row(
      children: [
        Spacer(),
        Text("We",style: TextStyle(fontSize: 24,color: Colors.black54),),
        Text("Connect         ",style: TextStyle(fontSize:25,color: Colors.blue,fontWeight: FontWeight.bold)),
        Spacer(),
      ],
    ),),body: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(onChanged: (val){
                setState(() {
                username=val;
              });
                searchInitiate(1);
                },decoration: InputDecoration(hintText: "Enter username",),)),


              Icon(Icons.search,

              size: 35,color: Colors.blue,),

            ],
          ),

         SizedBox(height: 20,),

         searchList(),
        ],
      ),
    )
      ,);
  }
}

createChatRoom(String username,BuildContext context)
{
  print("Pay attention");
  SharedPrefs.getName().then((value) {
    Constants.name=value;
    DatabaseServices _dbs=new DatabaseServices();
    String chatroomid=getChatRoomID(username, Constants.name);
    //String chatroomid="Hello";
    List<String> users=[username,Constants.name];
    Map<String,dynamic> chatData=
    {
      "users":users,
      "chatroomid":chatroomid
    };
    _dbs.createChatRoom(chatroomid, chatData);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatConversation(chatroomid: chatroomid,friendname: username,)));
  });


}


class SearchTile extends StatelessWidget
{


  BuildContext context;
  String username="hi";
  String email="hi";
  SearchTile({@required this.email, @required this.username, @required this.context});
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(username,style: TextStyle(fontSize: 20),softWrap: true,),
          Text(email, style: TextStyle(fontSize: 17
          ),softWrap: true,),
        ],),
        Spacer(),
        InkWell(onTap:(){createChatRoom(username, context);},child: Container(decoration:BoxDecoration(color:Colors.blue,borderRadius: BorderRadius.circular(20)),padding:EdgeInsets.all(10),child: Text("Message",style: TextStyle(fontSize: 16,color: Colors.white),))),
      ],),
    );
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
