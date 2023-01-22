import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widget/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  // const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String userName,
    XFile? userImage,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(File(userImage!.path)).whenComplete(() => null);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userName': userName,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err != null) {
        message = err.toString();
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 197, 64, 128),

      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 60,
            width: 50,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 231, 152, 208),
              border: Border.all(width: 2, color: Colors.white),
              shape: BoxShape.rectangle,
            ),
            child: const Center(
              child: Text(
                'Flutter Chat',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          AuthForm(
            _submitAuthForm,
            _isLoading,
          ),
        ],
      ),
      // ),
    );
  }
}
