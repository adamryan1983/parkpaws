import 'package:flutter/material.dart';
import '../routes/routes.dart';
import '../constants/colors.dart';
import '../subpages/search.dart';
import '../subpages/about.dart';
import '../subpages/add.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: AppColors.GREYBG,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.search,
            text: 'Search doggy-base for dogs',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const SearchPage()));
            },
          ),
          _createDrawerItem(
            icon: Icons.add,
            text: 'Add a dog to the doggy-base',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const AddPage()));
            },
          ),
          _createDrawerItem(
            icon: Icons.add,
            text: 'About The App',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const AboutPage()));
            },
          ),
          const Divider(),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.home)),
        ],
      ),
    ));
  }

  Widget _createHeader() {
    return SizedBox(
        height: 150,
        child: DrawerHeader(
            margin: const EdgeInsets.fromLTRB(4, 50, 4, 10),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: AssetImage(
                      "assets/images/logogrey.png",
                    ))),
            child: Stack()));
  }

  Widget _createDrawerItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.ORANGEPOP),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text!),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
