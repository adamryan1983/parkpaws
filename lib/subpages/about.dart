import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../widgets/drawer.dart';
import 'dart:io' show Platform;

class AboutPage extends StatelessWidget {
  static const String routeName = '/about';

  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("About The App"),
        ),
        body: const Info());
  }

  getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        // Display current offering with offerings.current
      }
    } on PlatformException catch (e) {
      // optional error handling
    }
  }
}

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Park Paws is a mobile app for locating dogs in the park.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        ElevatedButton(
            onPressed: () async {
              await Purchases.purchaseProduct('parkpaws_1_support');
            },
            child: const Text('Buy Park Paws Pro')),
        const Text('Creator: Adam Ryan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 20, child: const AboutPage().getOfferings()),
      ],
    );
  }
}

// Future<void> initPlatformState() async {
//   await Purchases.setDebugLogsEnabled(true);

//   PurchasesConfiguration configuration;
//   if (Platform.isAndroid) {
//     configuration = PurchasesConfiguration("public_google_sdk_key");
//   } else if (Platform.isIOS) {
//     configuration = PurchasesConfiguration("public_ios_sdk_key");
//   }
//   await Purchases.configure(configuration);
// }
