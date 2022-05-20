import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatUserInfo.dart';

class ChatScreen extends StatefulWidget {
  final Map data;
  ChatScreen({required this.data});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var msg = "";
  List msgsArr = [];
  var msgController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  var chatId;
  var msgDetails = {};
// Map chatMap={};
// List chatMsgs=[];
  final ScrollController myScrollController = ScrollController();

  void initState() {
    // chatMap=getChat() as Map;
    getChat();
    print("CHAT MSGS INIT STATE===========>${msgsArr}");
    print(
        "myScrollController.hasClients===========>${myScrollController.hasClients}");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scrollDown();
      //code will run when widget rendering complete
    });
    super.initState();
  }

// This is what you're looking for!
  scrollDown() {
    print(
        "myScrollController.hasClients===========>${myScrollController.hasClients}");
    if (myScrollController.hasClients) {
      final position = myScrollController.position.maxScrollExtent;
      print("JUMP++++++++>${position}");
      myScrollController.jumpTo(position);
    }
  }

  getChat() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (widget.data["userData"]["uId"]
            .compareTo(widget.data["chatUserData"]["uId"]) ==
        -1) {
      chatId =
          "${widget.data["userData"]["uId"]}_${widget.data["chatUserData"]["uId"]}";
    } else {
      chatId =
          "${widget.data["chatUserData"]["uId"]}_${widget.data["userData"]["uId"]}";
    }

    DocumentSnapshot ds = await db.collection("chats").doc(chatId).get();
    if (ds.exists) {
      msgsArr = ds.get('chat');
    }
    // var chatArr = await db
    //     .collection('chats')
    //     .doc(chatId)
    //     .get();
    //       Map myMap = chatArr.data() as Map;
    //   print("map data------>${myMap}");
    // print("CHATARR------------->${chatArr}");
    //       return myMap;
  }

  msgSavedToFirebase() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var msg = msgController.text;

      if (widget.data["userData"]["uId"]
              .compareTo(widget.data["chatUserData"]["uId"]) ==
          -1) {
        chatId =
            "${widget.data["userData"]["uId"]}_${widget.data["chatUserData"]["uId"]}";
      } else {
        chatId =
            "${widget.data["chatUserData"]["uId"]}_${widget.data["userData"]["uId"]}";
      }

      print("chatId====>${chatId}");
      if (msg != "") {
        msgDetails = {
          "to": widget.data["userData"]["fullname"],
          "from": widget.data["chatUserData"]["fullname"],
          "msg": msg,
          // "time":TimeOfDay.now()
          // "date":
        };
        setState(() {
          // chatMsgs.add(msgDetails);
          msgsArr.add(msgDetails);
          msg = "";
          msgController.clear();
        });
      }
      await db.collection("chats").doc(chatId).set({
        "chat": msgsArr,
        // "chat": chatMsgs,
      });

      print("Chat Added succesfully....");
      print(
          "myScrollController.hasClients===========>${myScrollController.hasClients}");
      //  Future.delayed.call(scrollDown());
      //  then(scrollDown());
      //  scrollDown();
      // var chatArr = FirebaseFirestore.instance
      //     .collection('chats')
      //     .doc("${widget.data["myId"]}_${widget.data["uId"]}")
      //     .collection('chat')
      //     .get();
      // print("ChatArr firebase========>${chatArr}");
    } catch (e) {
      print("Error ${e}");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("error:${e}"),
            );
          });
    }
  }

  // msgSavedToArr() {
  //   if (msg != "") {
  //     setState(() {
  //       msgsArr.add(msg);
  //       msg = "";
  //       msgController.clear();
  //     });
  //   }
  // }
  final Stream<QuerySnapshot> _chatStream =
      FirebaseFirestore.instance.collection('chats').snapshots();

  @override
  Widget build(BuildContext context) {
// getChat();

    print("home to chat===>${widget.data}");
    // print("chat Map===>${chatMap}");
    print("chat Msgs===>${msgsArr}");
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 75,
          actions: [
            // Icon(Icons.video_call),
            // SizedBox(width: 10),
            // Icon(Icons.add_call),
            // SizedBox(width: 10),
            // ignore: prefer_const_constructors
            GestureDetector(
                onTap: scrollDown, child: Icon(Icons.more_vert_sharp)),
          ],

          // backgroundColor: Colors.green,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatUserInfoScreen(
                          data: widget.data["chatUserData"])));
            },
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
              ],
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatUserInfoScreen(
                          data: widget.data["chatUserData"])));
            },
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.data['chatUserData']['fullname']}"),
                      Text(
                        "online",
                        style: TextStyle(fontSize: 12),
                      ),
                    ]),
              ],
            ),
          )),
      body: 
    );
  }
}
