import 'package:flutter/material.dart';

// //import 'package:cloud_firestore/cloud_firestore.dart';
import './screen/chat_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import './screen/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ))),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        }),
      ),
      // AuthScreen(),

      //  FutureBuilder(
      //   future: Firebase.initializeApp(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return ChatScreen();
      //     }
      //   },
      // ),
    );
  }
}
