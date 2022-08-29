import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class AddPage extends StatelessWidget {
  static const String routeName = '/add';

  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Add Dog"),
        ),
        body: const Add());
  }
}

class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text('Add Dog.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        Text('Creator: Adam Ryan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
