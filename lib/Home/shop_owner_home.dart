import 'package:covilog/style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShopOwnerHomeBody(),
    );
  }
}

FirebaseAuth auth = FirebaseAuth.instance;

String printID() {
  User user = auth.currentUser;
  String id = user.uid;
  String data = id;
  return data;
}

Future merchantProfile() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser;
  final uid = user.uid;
  DatabaseReference merchantsprofileRef =
      FirebaseDatabase.instance.reference().child("merchantusers").child(uid);

  return merchantsprofileRef.once();
}

class ShopOwnerHomeBody extends StatelessWidget {
  // no need of the file extension, the name will do fine.

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<dynamic>(
              future: merchantProfile(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container(
                  width: 280,
                  //decoration: BoxDecoration(color: Colors.white),
                  child: ListTile(
                    //tileColor: Color(0xff000000),
                    leading: Container(
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data.value['name'],
                          style: subH,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          snapshot.data.value['email'],
                          style: smallLabel,
                        ),
                      ],
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 40,
          ),
          //QR Code
          PrettyQr(
              typeNumber: 3,
              size: 200,
              data: printID(),
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true),
          SizedBox(
            height: 40,
          ),
          Text(
            'Scan the QR code to enter',
            //textAlign: TextAlign.center,
            style: bodytxtstyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                //minWidth: double.infinity,
                minHeight: 46,
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'shop_owner_summery');
                },
                color: Colors.tealAccent[700],
                textColor: Colors.white,
                child: Text(
                  'Customer Log',
                  style: button,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () async {
              final SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();

              //Remove int
              sharedPreferences.remove('value');

              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'onboard', (route) => false);
            },
            child: Text(
              'Signout',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.tealAccent[700],
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
