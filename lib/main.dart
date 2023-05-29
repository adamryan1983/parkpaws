import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkpaws/controllers/dog_listing_controller.dart';
import 'package:parkpaws/routes/routes.dart';
import 'constants/colors.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'error.dart';
import 'firebase_options.dart';
import 'dart:io' show Platform;
import 'constants/store_config.dart' as sc;
import 'constants/apikeys.dart';

Future main() async {
  // dotenv.load(fileName: ".env");
  if (Platform.isIOS || Platform.isMacOS) {
    sc.StoreConfig(
      store: sc.Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    sc.StoreConfig(
      store: sc.Store.googlePlay,
      apiKey: googleApiKey,
    );
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  final DogListingController dogAmount = Get.put(DogListingController());

  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppExtended());
}

final _navigatorKey = GlobalKey<NavigatorState>();

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
  const MyApp({super.key});
  // final controller = Get.put(DogListingController());
  static const String supportTier = '123';
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Park Paws',
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.home,
      theme: AppTheme.lightTheme,
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
          // print('successfully loaded db');
          return const MyApp();
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
