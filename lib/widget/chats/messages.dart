// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chats/message_bubble.dart';

class Messages extends StatelessWidget {
  Future<bool> _getUser(id) async {
    final user = await FirebaseAuth.instance.currentUser;
    return user!.uid == id;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final user = FirebaseAuth.instance.currentUser;

          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) => MessageBubble(
                  snapshot.data!.docs[index]['text'],
                  user!.uid == snapshot.data!.docs[index]['userId'],
                  snapshot.data!.docs[index]['userName'],
                  snapshot.data!.docs[index]['userImage'],
                  KEY: ValueKey(snapshot.data!.docs[index].toString()),
                )),
          );
        }));
  }
}
