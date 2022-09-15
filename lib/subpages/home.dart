import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkpaws/constants/colors.dart';
import 'package:parkpaws/routes/routes.dart';
import 'package:parkpaws/widgets/drawer.dart';
import 'package:parkpaws/controllers/dog_listing_controller.dart';

class Home extends GetWidget {

  Home({super.key});

  final DogListingController dogs = Get.find();

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: const Color(0xFFD9D9D9),
            drawer: const AppDrawer(),
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text("Park Paws",
                  style: TextStyle(fontFamily: 'Borsok')),
              backgroundColor: AppColors.DARKREDACCENT,
            ),
            body: Center(
              //background color
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
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
                            onPressed: (() =>
                                Navigator.pushNamed(context, Routes.search)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.search,
                                    color: AppColors.MAINTEXTWHITE),
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
                                Navigator.pushNamed(context, Routes.add)),
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
                        //add dog amount here
                        Obx(() => Text(
                  "Registered dogs: ${dogs.allDogs().length}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.MAINTEXTBLACK),
                )),
                      ]),
                ],
              ),
            ),
          );
        
}
}
