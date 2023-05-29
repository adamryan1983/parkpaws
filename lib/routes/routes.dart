import 'package:flutter/material.dart';
import '../subpages/about2.dart';
import '../subpages/add.dart';
import '../subpages/search.dart';
import '../subpages/home.dart';
import '../subpages/purchase.dart';


class Routes {

  static const String about = '/about';
  static const String add = '/add';
  static const String search = '/search';
  static const String home = '/';
  static const String purchase = '/purchase';


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
      case purchase:
        return MaterialPageRoute(builder: (_) => const PurchaseTester());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
