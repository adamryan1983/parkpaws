// ignore_for_file: file_names, equal_keys_in_map
import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'widgets/drawer.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'subpages/about.dart';
import 'subpages/add.dart';
import 'subpages/search.dart';

Future main() async {
  // dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    title: 'Park Paws',
    initialRoute: '/',
    routes: {
      '/': (context) => const MyApp(),
      '/about': (context) => const AboutPage(),
      '/add': (context) => const AddPage(),
      '/search': (context) => const SearchPage(),
    },
  ));
}

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Quicksand',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: AppColors.DARKREDACCENT,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.white,
      secondary: Colors.blue,
    ),
    cardTheme: const CardTheme(
      color: Colors.blue,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.ORANGEPOP,
    ),
  );

//   static final ThemeData darkTheme = ThemeData(
//     fontFamily: 'Quicksand',
//     scaffoldBackgroundColor: Colors.white,
//     appBarTheme: const AppBarTheme(
//       color: AppColors.secondaryColor,
//       iconTheme: IconThemeData(
//         color: Colors.black,
//       ),
//     ),
//     colorScheme: const ColorScheme.light(
//       primary: Colors.black,
//       onPrimary: Colors.black,
//       primaryVariant: Colors.black,
//       secondary: Colors.red,
//     ),
//     cardTheme: const CardTheme(
//       color: Colors.black,
//     ),
//     iconTheme: const IconThemeData(
//       color: AppColors.fifthColor,
//     ),
//   );
// }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String routeName = '/';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Park Paws',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Quicksand',
        backgroundColor: AppColors.GREYBG,
        primaryColor: AppColors.DARKREDACCENT,
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFD9D9D9),
        drawer: const AppDrawer(),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Park Paws"),
          backgroundColor: AppColors.DARKREDACCENT,
        ),
        body: Center(
          //background color
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                'Welcome to Park Paws!',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Borsok',
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/images/logogrey.png',
                height: 300,
                width: 300,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.DARKORANGE,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/search');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.search, color: AppColors.MAINTEXTWHITE),
                            Text('Search the doggy-base',
                                style: TextStyle(
                                    color: AppColors.MAINTEXTWHITE,
                                    fontSize: 20)),
                          ],
                        )),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.DARKORANGE,
                        ),
                        onPressed: (() =>
                            Navigator.pushNamed(context, AddPage.routeName)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add_circle,
                                color: AppColors.MAINTEXTWHITE),
                            Text('Add a doggy',
                                style: TextStyle(
                                    color: AppColors.MAINTEXTWHITE,
                                    fontSize: 12)),
                          ],
                        )),
                  ]),
            ],
          ),
        ),
      ),
      // routes: {
      //   Routes.add: (context) => const AddPage(),
      //   Routes.about: (context) => const AboutPage(),
      //   Routes.search: (context) => const SearchPage(),
      //   Routes.home: (context) => const MyApp(),
      // },
    );
  }
}
