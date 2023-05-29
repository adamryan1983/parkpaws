import 'package:flutter/material.dart';
import 'constants/colors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Park Paws!',
        theme: ThemeData(
            fontFamily: 'Work',
            primaryColor: AppColors.ORANGEPOP, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(background: AppColors.MAINBGWHITE)),
        home: const ErrorPageExtended());
  }
}

class ErrorPageExtended extends StatelessWidget {
  const ErrorPageExtended({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Image.asset('assets/images/moooseheaderlight.png',
            fit: BoxFit.cover, width: 150),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Uh Oh!',
              style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ORANGEPOP),
            ),
            Image.asset('assets/images/mooose-logo.png', width: 270),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  'Error Loading. Please close the app and try again.',
                  style: TextStyle(fontSize: 18),
                )),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: const Text(
                  'Click here to try again',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ORANGEPOP),
                )),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
