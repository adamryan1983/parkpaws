import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkpaws/controllers/dog_listing_controller.dart';
import 'package:parkpaws/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkpaws/constants/colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Search());
  }
}

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() {
    return SearchState();
  }
}

class SearchState extends State<Search> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Park Paws',
        home: Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              alignment: Alignment.center,
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Find Doggy',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Borsok',
                                  color: AppColors.MAINTEXTBLACK)),
                          Image.asset(
                            'assets/images/dogheader1.png',
                            height: 120,
                            width: 120,
                          ),
                        ],
                      ),
                      CupertinoFormSection(
                        header: const Text('Search Doggy-base for Dog Match'),
                        children: [
                          SizedBox(
                            width: 350,
                            child: CupertinoFormRow(
                              prefix: const Text('Color'),
                              child: CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                controller: _colorController,
                                placeholder: 'Enter the dog\'s color',
                              ),
                            ),
                          ),
                          const Text('Or'),
                          SizedBox(
                            width: 350,
                            child: CupertinoFormRow(
                              prefix: const Text('Name'),
                              child: CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                controller: _nameController,
                                placeholder: 'Enter the dog\'s name',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_colorController.text.isNotEmpty &&
                                      _nameController.text.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please only fill in one field')));
                                  } else if (_colorController.text.isNotEmpty ||
                                      _nameController.text.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultsPage(
                                          _colorController.text,
                                          _nameController.text,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter a color or name')));
                                  }
                                }
                                // Validate returns true if the form is valid, or false otherwise.
                              },
                              child: const Text('Search'),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                Navigator.pushNamed(context, Routes.home);
                              },
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          ]),
        ));
  }
}

class ResultsPage extends StatelessWidget {
  final String colorQuery;
  final String nameQuery;

  const ResultsPage(
    this.colorQuery,
    this.nameQuery, {
    Key? key,
  }) : super(key: key);
  Widget _buildListItem(BuildContext context, DocumentSnapshot docs) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${docs['name']}"),
              Text("Color: ${docs['color']}"),
              Text("DOB: ${docs['dob']}"),
              Text("Owner: ${docs['parent']}"),
              Text("Site: ${docs['site']}"),
              Text("Photo: ${docs['photo']}"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: loadImage(docs['photo'].toString()),
                builder: (BuildContext context, AsyncSnapshot<String> image) {
                  if (image.hasData) {
                    return Image.network(
                      image.data.toString(),
                      width: 200,
                      height: 200,
                    ); // image is ready
                    //return Text('data');
                  } else {
                    return const Text('...loading image'); // placeholder
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
    // child: ListTile(
    //   title: Text("Name: ${docs['name']}"),
    //   subtitle: Text("Color: ${docs['color']}"),
    //   onTap: () {},
    // ),
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for $colorQuery'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dogs')
            // .where(query)
            .where(colorQuery.isEmpty ? 'name' : 'color',
                isEqualTo: colorQuery.isEmpty
                    ? nameQuery.toLowerCase()
                    : colorQuery.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('Loading...');
          } else if (snapshot.data!.docs.isEmpty) {
            return const Text('No results found');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, snapshot.data!.docs[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.home);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}

Future<String> loadImage(String filename) async {
  //select the image url
  Reference ref =
      FirebaseStorage.instance.ref().child("dogs/$filename");

  //get image url from firebase storage
  var url = await ref.getDownloadURL();
  return url;
}

final DogListingController dogs = Get.find();

final dogList = dogs.allDogs();
