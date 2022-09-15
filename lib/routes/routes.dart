import 'package:flutter/material.dart';
import '../subpages/about.dart';
import '../subpages/add.dart';
import '../subpages/search.dart';
import '../subpages/home.dart';


class Routes {

  static const String about = '/about';
  static const String add = '/add';
  static const String search = '/search';
  static const String home = '/';


  static Route<dynamic> generateRoute(RouteSettings settings) {
   switch (settings.name) {
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case add:
        return MaterialPageRoute(builder: (_) => const AddDog());
      case home:
        return MaterialPageRoute(builder: (_) => Home());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
