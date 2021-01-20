import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices
{

  Future getUserfromUserName(String name, int x)
  {
    if(x==0) {
      return FirebaseFirestore.instance.collection("users").get();
    }
    else if(x==1)
      {
        if(name.isEmpty) return FirebaseFirestore.instance.collection("users").get();
        else return FirebaseFirestore.instance.collection("users").where('Name',isGreaterThanOrEqualTo: name).where('Name',isLessThan: name + 'z').get();
      }
  }
  
  Future getUserFromEmail(String email)
  {
    return FirebaseFirestore.instance.collection("users").where('Email',isEqualTo: email).get();
  }
  
   getChatRoomsFromName(String name) async
  {
    return FirebaseFirestore.instance.collection("chatrooms").where('users',arrayContains: name).snapshots();
  }
  uploadUserInfo(userMap)
  {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatid, chatMap)
  {
    FirebaseFirestore.instance.collection("chatrooms").doc(chatid).set(chatMap).catchError((e)
    {
      print(e.toString());
    });
  }
  
  addChatMessage(String chatid, MessageMap) async
  {


    FirebaseFirestore.instance.collection("chatrooms").doc(chatid).collection("messages").get().then((value)
    {

      String docindex=(value.docs.length+1).toString();
      MessageMap['order']=int.parse(docindex);
     FirebaseFirestore.instance.collection("chatrooms").doc(chatid).collection("messages").doc(docindex).set(MessageMap).catchError((e)
      {
        print(e.toString());
      });


    });


  }


  getChatMessages(String chatid) async
  {
    //return await FirebaseFirestore.instance.collection("chatrooms").doc(chatid).collection("messages").snapshots();
    return await FirebaseFirestore.instance.collection("chatrooms").doc(chatid).collection("messages").orderBy('order').snapshots();

  }
  
  getLastMessage(String chatid) async
  {
    FirebaseFirestore.instance.collection("chatrooms").doc(chatid).collection("messages").get().then((value)
    {
          int l=value.docs.length;

          FirebaseFirestore.instance.collection("chatrooms").doc(chatid).collection("messages").doc(l.toString()).get().then((val)
          {
            return val.get('message').toString();
          });
    });
  }
  Future<DocumentSnapshot> getLastMessages(String chatid) async
  {
    FirebaseFirestore.instance.collection("chatrooms").doc(chatid).collection("messages")..orderBy('order',descending: true).get().then((value)
    {
      return value.docs[0];
    });

  }
}