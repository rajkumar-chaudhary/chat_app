import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/widget/picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  //const AuthForm({super.key});
  AuthForm(
    this.submitFn,
    this.isLoad,
  );
  final bool isLoad;
  final Function(
    String email,
    String password,
    String userName,
    XFile? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  XFile? _UserImage;

  void _imagePick(XFile? img) {
    _UserImage = img;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_UserImage == null && !_isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please pick a Image')));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _UserImage,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_imagePick),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Plese enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('userName'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Plese enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be 7 characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoad) CircularProgressIndicator(),
                  if (!widget.isLoad)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have a account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
