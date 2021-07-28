import 'package:firebase_auth/firebase_auth.dart';
import 'package:covilog/style/text_style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerHome extends StatefulWidget {
  CustomerHome({Key key}) : super(key: key);

  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

FirebaseAuth auth = FirebaseAuth.instance;

String printID() {
  User user = auth.currentUser;
  String id = user.uid;
  String data = id;
  return data;
}

class _CustomerHomeState extends State<CustomerHome> {
  Query _ref;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(printID())
        .child('merchantusers')
        .orderByChild('name');
  }

  Widget _buildContactItem({Map contact}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: ListTile(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact['shopname'],
              style: subH,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              contact['date'],
              style: smallLabel,
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                contact['time'],
                style: smallLabel,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future userProfile() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    DatabaseReference merchantsprofileRef =
        FirebaseDatabase.instance.reference().child("users").child(uid);

    return merchantsprofileRef.once();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: userProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // return CircularProgressIndicator();
          }
          return Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(25.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'qr_code_scanner');
                },
                backgroundColor: Colors.tealAccent[700],
                child: Icon(Icons.qr_code),
              ),
            ),
            appBar: AppBar(
              // leading: Container(
              //   padding: EdgeInsets.all(13),
              //   child: SvgPicture.asset(
              //     'assets/menu.svg',
              //     color: Colors.white,
              //   ),
              // ),
              backgroundColor: Colors.tealAccent[700],
              title: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'CoviLog',
                  style: h2,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                PopupMenuButton(
                  onSelected: (choice) async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();

                    //Remove int
                    sharedPreferences.remove('value');

                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'customer_login', (route) => false);
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: Center(
                        child: Text(
                          "Signout",
                          style: labelBlack,
                        ),
                      ),
                      value: "signout",
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.only(right:25.0),
                    child: Icon(Icons.logout),
                  )
                ),
              ],
            ),
            body: Container(
              height: double.infinity,
              child: FirebaseAnimatedList(
                query: _ref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map contact = snapshot.value;
                  return _buildContactItem(contact: contact);
                },
              ),
            ),
            
          );
        });
  }
}
