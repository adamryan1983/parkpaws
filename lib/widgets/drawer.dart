import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:parkpaws/routes/routes.dart';

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
              onTap: (() => Navigator.pushNamed(context, Routes.search))),
          _createDrawerItem(
              icon: Icons.add,
              text: 'Add a dog to the doggy-base',
              onTap: (() => Navigator.pushNamed(context, Routes.add))),
          _createDrawerItem(
              icon: Icons.info,
              text: 'About The App',
              onTap: (() => Navigator.pushNamed(context, Routes.about))),
          const Divider(),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: (() => Navigator.pushNamed(context, Routes.home)))
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
