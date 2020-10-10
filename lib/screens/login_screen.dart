import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/resources/firebase_methods.dart';
import 'package:skype_clone/extras/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMethods _firebase = FirebaseMethods();
  bool _loginButtonPressed = false;

  Future<void> _performLogin() async {
    setState(() => _loginButtonPressed = true);
    User user = await _firebase.signInWithGoogle();
    if (user == null) {
      setState(() => _loginButtonPressed = false);
      return;
    }
    bool _isNewUser = await _firebase.isNewUser(user);
    if (_isNewUser) await _firebase.addUserToDb(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UnivVars.blackColor,
      body: Center(
        child: _loginButtonPressed
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : GoogleSigninButton(performLogin: _performLogin),
      ),
    );
  }
}

class GoogleSigninButton extends StatelessWidget {
  final Future<void> Function() performLogin;
  const GoogleSigninButton({@required this.performLogin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: performLogin,
      child: Container(
        width: 260.0,
        height: 60.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/google_signin_button.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
