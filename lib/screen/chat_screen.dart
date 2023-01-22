import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widget/chats/messages.dart';
import '../widget/chats/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // const ChatScreen({Key key}) : super(key: key);

  @override
  void initState() {
    Init();
    final fbm = FirebaseMessaging.instance;
    // fbm.

    super.initState();
  }

  Init() async {
    String deviceTOken = await getDeviceTOken();
    print("TOKEN");
    print(deviceTOken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ]),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }

  Future getDeviceTOken() async {
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }
}





















      //  StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('chats/PHXQbrUJLYGt3BclcVsk/messages')
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator.adaptive());
      //     }
      //     final documents = snapshot.data!.docs.reversed.toList();
      //     return ListView.builder(
      //       padding: const EdgeInsets.all(8),
      //       itemBuilder: (ctx, i) => Container(
      //         child: Text(documents[i]['text']),
      //       ),
      //       itemCount: snapshot.data?.docs.length,
      //     );
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add_outlined),
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection('chats/PHXQbrUJLYGt3BclcVsk/messages')
      //         .add({
      //       'text': 'this was added by clicking',
      //     });

      //     //     .listen((event) {
      //     //   event.docs.forEach((element) {
      //     //     debugPrint(element['text']);
      //     //   });
      //     // }

      //     // );
      //   },
      // ),
   
