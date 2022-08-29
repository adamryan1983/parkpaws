import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class SearchPage extends StatelessWidget {
  static const String routeName = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Search for Dog"),
        ),
        body: const Search());
  }
}

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text('Search Dog.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        Text('Creator: Adam Ryan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
