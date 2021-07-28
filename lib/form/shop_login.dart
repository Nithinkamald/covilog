import 'package:covilog/form/customer_signup.dart';
import 'package:covilog/style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ShopLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.west),
          onTap: () {
            Navigator.pushNamed(context, 'onboard');
          },
        ),
        title: Text(
          'CoviLog',
          style: h2,
        ),
        backgroundColor: Colors.tealAccent[700],
      ),
      body: SingleChildScrollView(
        child: ShopLoginFormContents(),
      ),
    );
  }
}

class ShopLoginFormContents extends StatefulWidget {
  @override
  _ShopLoginFormContentsState createState() => _ShopLoginFormContentsState();
}

class _ShopLoginFormContentsState extends State<ShopLoginFormContents> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Text(
            //'Welcome back! Please login to continue.',
            'Login as Shop',
            textAlign: TextAlign.left,
            style: textBtn,
          ),
          SizedBox(
            height: 8,
          ),
          TextFieldContainer(
            controller: emailTextEditingController,
            label: 'Email',
            type: TextInputType.emailAddress,
            pass: false,
          ),
          TextFieldContainer(
            controller: passwordTextEditingController,
            label: 'Password',
            type: TextInputType.text,
            pass: true,
            eyeIcon: Icons.visibility,
          ),
        
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 46,
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  if (!emailTextEditingController.text.contains("@")) {
                    displayToastMessage("Email address is not valid", context);
                  } else if (passwordTextEditingController.text.isEmpty) {
                    displayToastMessage("Password is mandatory.", context);
                  } else {
                    loginAndAuthenticateUser(context);
                  }
                },
                color: Colors.tealAccent[700],
                textColor: Colors.white,
                child: Text(
                  'Login',
                  style: button,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Don\'t have account?',
                  textAlign: TextAlign.left,
                  style: bodytxtstyle,
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'shop_owner_signup');
                  },
                  child: Text(
                    'Create one',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.tealAccent[700],
                      fontFamily: 'Montserrat',
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      merchantRef
          .child(firebaseUser.uid)
          .once()
          .then((DataSnapshot snap) async {
        if (snap.value != null) {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setInt('value', 2);

          Navigator.pushNamedAndRemoveUntil(
              context, 'shop_owner_home_screen', (route) => false);
          displayToastMessage("login successful", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "User does not exist. Create new account.",
              context);
        }
      });
    } else {
      displayToastMessage("Error Occured", context);
    }
  }
}
