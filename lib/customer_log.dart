import 'package:firebase_auth/firebase_auth.dart';
import 'package:covilog/style/text_style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ShopOwnerSummery extends StatefulWidget {
  ShopOwnerSummery({Key key}) : super(key: key);

  @override
  _ShopOwnerSummeryState createState() => _ShopOwnerSummeryState();
}

FirebaseAuth auth = FirebaseAuth.instance;

String printID() {
  User user = auth.currentUser;
  String id = user.uid;
  String data = id;
  return data;
}

class _ShopOwnerSummeryState extends State<ShopOwnerSummery> {
  Query _ref;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('merchantusers')
        .child(printID())
        .child('users')
        .orderByChild('name');
  }

  Widget _buildContactItem({Map contact}) {
    // if (contact["vacc"])
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: ListTile(
        //tileColor: Colors.grey,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact['name'],
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              contact['time'],
              style: smallLabel,
            ),
            SizedBox(
              height: 4,
            ),
            Icon(
              Icons.tour,
              size: 22,
              color:
                  (contact['Vaccinated'] == 'Yes') ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent[700],
        title: Text(
          'Customer Log',
          style: h2,
        ),
        // automaticallyImplyLeading: true,
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(
        //       right: 16,
        //     ),
        //     child: GestureDetector(
        //       onTap: () {
        //         print('Filter');
        //       },
        //       child: Icon(
        //         Icons.filter_list,
        //       ),
        //     ),
        //   ),
        // ],
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
  }
}

// ignore: must_be_immutable
