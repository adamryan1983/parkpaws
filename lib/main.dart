// ignore_for_file: file_names, equal_keys_in_map
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants/colors.dart';
import 'widgets/drawer.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'subpages/about.dart';
import 'subpages/add.dart';
import 'subpages/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './error.dart';
import 'controllers/DogListingController.dart';

Future main() async {
  // dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(
    title: 'Park Paws',
    initialRoute: '/',
    routes: {
      '/': (context) => AppExtended(),
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
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  static const String routeName = '/';
  DogListingController dogs = Get.find();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Park Paws',
      theme: ThemeData(
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
          title: const Text("Park Paws", style: TextStyle(fontFamily: 'Borsok')),
          backgroundColor: AppColors.DARKREDACCENT,
        ),
        body: Center(
          //background color
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Container(
              //   margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              // child:const Text(
              //   'Welcome to Park Paws!',
              //   style: TextStyle(
              //     fontSize: 30,
              //     fontFamily: 'Borsok',
              //   ),
              //   textAlign: TextAlign.center,
              // )),
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
                        Text("$dogs.getAllDogs.length")
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

class AppExtended extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  AppExtended({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const ErrorPage();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print('successfully loaded db');
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading(key: UniqueKey());
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Center(child: Text("Issue Loading.")));
  }
}

class Loading extends StatelessWidget {
  const Loading({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Text("Loading up"));
  }
}
