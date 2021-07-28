import 'package:covilog/QR/qrCodeScanner.dart';
import 'package:covilog/form/shop_login.dart';
import 'package:covilog/form/shop_signup.dart';
import 'package:covilog/Home/customer_home.dart';
import 'package:covilog/Home/shop_owner_home.dart';
import 'package:covilog/form/customer_login.dart';
import 'package:covilog/form/customer_signup.dart';
import 'package:covilog/model/model.dart';
import 'package:covilog/show_owner_summery.dart';
import 'package:covilog/splash%20screens/loading_splash.dart';
import 'package:covilog/style/color.dart';
import 'package:covilog/style/text_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

int finalValue;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference merchantRef =
    FirebaseDatabase.instance.reference().child("merchantusers");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'covilog',
      routes: {
        'onboard': (context) => Home(),
        'customer_signup': (context) => SignupForm(),
        'customer_home_screen': (context) => CustomerHome(),
        'customer_login': (context) => CustomerLoginForm(),
        'shop_owner_home_screen': (context) => ShopOwnerHome(),
        'shop_owner_login': (context) => ShopLoginForm(),
        'shop_owner_signup': (context) => ShopSignupForm(),
        'qr_code_scanner': (context) => QRCodeScanner(),
        'shop_owner_summery': (context) => ShopOwnerSummery(),
        'splash_screen': (context) => LoadingSplashScreen(),
      },
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SliderModel> slides = new List<SliderModel>();
  int currentIndex = 0;

  void initState() {
    super.initState();
    slides = getSlides();
  }

  Widget buildPageIndicator(bool isCurrentPage) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.5),
        height: isCurrentPage ? 8.0 : 6.0,
        width: isCurrentPage ? 8.0 : 6.0,
        decoration: BoxDecoration(
          color: isCurrentPage ? Colors.tealAccent[700] : greyShade,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: slides.length,
        onPageChanged: (val) {
          setState(() {
            currentIndex = val;
          });
        },
        itemBuilder: (context, index) {
          return SliderTile(
            svgAsset: slides[index].getsvgAsset(),
            heading: slides[index].getHeading(),
            body: slides[index].getBody(),
          );
        },
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                i == currentIndex
                    ? buildPageIndicator(true)
                    : buildPageIndicator(false),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 46,
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'customer_login');
                  // getValidationData().whenComplete(() async {
                  //   (finalValue == 1)
                  //       ? Navigator.pushNamed(context, 'customer_home_screen')
                  //       : Navigator.pushNamed(context, 'customer_login');
                  // });
                },
                color: Colors.tealAccent[700],
                textColor: Colors.white,
                child: Text(
                  'Customer',
                  style: button,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 46,
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'shop_owner_login');
                  // getValidationData().whenComplete(() async {
                  //   (finalValue == 2)
                  //       ? Navigator.pushNamed(context, 'shop_owner_summery')
                  //       : Navigator.pushNamed(context, 'shop_owner_login');
                  // });
                },
                color: Colors.white,
                textColor: Colors.tealAccent[700],
                child: Text(
                  'Shop Owner',
                  style: button,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.tealAccent[700],
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SliderTile extends StatelessWidget {
  String svgAsset, heading, body;
  SliderTile({this.svgAsset, this.heading, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgAsset),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              heading,
              textAlign: TextAlign.center,
              style: h1,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              body,
              textAlign: TextAlign.center,
              style: bodytxtstyle,
            ),
          ),
          SizedBox(
            height: 48,
          ),
        ],
      ),
    );
  }
}
