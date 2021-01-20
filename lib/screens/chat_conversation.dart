import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/services/constants.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/sharedprefs.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

ScrollController controller=ScrollController();

bool check=false;

class ChatConversation extends StatefulWidget {
  ChatConversation({@required this.chatroomid, @required this.friendname});
  String chatroomid;
  String friendname;
    _ChatConversationState createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  Stream msgs=null;
  String message="";

  TextEditingController msg=TextEditingController();
  DatabaseServices dbs=new DatabaseServices();



  Widget ListOfMessages()
  {
    return msgs==null?Container():StreamBuilder(stream: msgs, builder: (context,snapshot)
    {
      return snapshot==null?Container():ListView.builder(controller: controller,itemCount: snapshot.data.docs.length,itemBuilder: (context, index)
      {

        return MessageTile(message: snapshot.data.docs[index].get('message'), sender: snapshot.data.docs[index].get('sender'), docid:snapshot.data.docs[index].documentID);
      },);
    },);
  }
  addMessagetoDatabase()
  {
    if(message.isNotEmpty) {
      SharedPrefs.getName().then((value)
      {


        Map<String, dynamic> messageMap =
        {
          "message": message,
          "sender": value
        };
        dbs.addChatMessage(widget.chatroomid, messageMap).then((val)
        {
          msg.clear();
          message="";
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          //controller.jumpTo(controller.position.maxScrollExtent);
          Timer(Duration(milliseconds: 500), () {
            controller.jumpTo(controller.position.maxScrollExtent);

          });
          Timer(Duration(milliseconds: 700), () {
            controller.jumpTo(controller.position.maxScrollExtent);

          });

        });
      });
    }

  }

  @override
  void initState() {
    dbs.getChatMessages(widget.chatroomid).then((value)
    {

      setState(() {
        msgs=value;
      });


    });

    super.initState();
  }

  afterBuild()
  {
    print("CALCALCALCALCALCAL");
    //Timer(duration:)controller.jumpTo(controller.position.maxScrollExtent);
    Timer(Duration(milliseconds: 700), () {controller.jumpTo(controller.position.maxScrollExtent);check=true;});
  }


  @override
  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((_) { afterBuild();});
    return Scaffold(backgroundColor:Colors.white,appBar: AppBar(iconTheme:IconThemeData(color: Colors.black45),elevation: 0.0,backgroundColor: Colors.transparent,title: Text(widget.friendname,style: TextStyle(color: Colors.black,fontSize: 22),),),
      body: Container(child: Stack(children: [
        Container(child: ListOfMessages(), padding: EdgeInsets.only(bottom: 80),),

        Container(alignment:Alignment(1,0.99),child: Container(margin:EdgeInsets.symmetric(horizontal: 20,vertical: 10),padding:EdgeInsets.only(left: 20),decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: /*Color(0xFFe3e3cf)*/ Colors.white,border: Border.all(color:Color(0xFFe3e3cf),width: 2.0 )),
          child: Row(
            children: [
              Expanded(child: TextField(controller: msg,onChanged: (val){message=val;},decoration: InputDecoration(border:InputBorder.none,hintText: "Enter message..",hintStyle: TextStyle(fontSize: 18)),)),
              Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blue),child: IconButton(icon: Icon(Icons.send,size: 26,color: Colors.white,),onPressed: ()
              {
                addMessagetoDatabase();
                //msg.clear();
              },))
            ],
          ),
        ),)
      ],),),);
  }
}
int count=0;
int doccount=0;
class MessageTile extends StatelessWidget
{
  MessageTile({@required this.message, @required this.docid,@required this.sender});
  String message="test",sender="test",docid="0";



  @override
  Widget build(BuildContext context) {
    if(int.parse(docid)>doccount)
    {
      doccount++;
      print(doccount);
      if(sender!=Constants.name && check)
      {
        Timer(Duration(milliseconds: 700), () {controller.jumpTo(controller.position.maxScrollExtent);});
      }
    }
    print("Count =" + (++count).toString());
    return sender!=Constants.name?Row(
      children: [

        Container(constraints:BoxConstraints(maxWidth: 300),decoration:BoxDecoration(color:  Color(0xFFebf5ee),borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15),bottomRight: Radius.circular(15))),margin:EdgeInsets.fromLTRB(10, 2.6, 5, 2.6),padding:EdgeInsets.fromLTRB(10, 10, 10, 10),child: Text(message,style: TextStyle(color: Colors.black,fontSize: 18),),),
      ],
    ):
    Row(
      children: [
        Spacer(),
        Container(constraints:BoxConstraints(maxWidth: 300),decoration:BoxDecoration(color:  Colors.lightBlue,borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15),bottomRight: Radius.circular(15))),margin:EdgeInsets.fromLTRB(10, 2.6, 5, 2.6),padding:EdgeInsets.fromLTRB(10, 10, 10, 10),child: Text(message,style: TextStyle(color: Colors.white,fontSize: 18),),),
      ],
    );


  }
}
