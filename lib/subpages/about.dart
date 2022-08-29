import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

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
}

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text('Park Paws is a mobile app for locating dogs in the park.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        Text('Creator: Adam Ryan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
