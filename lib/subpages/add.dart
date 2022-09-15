import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkpaws/constants/colors.dart';
import 'package:parkpaws/routes/routes.dart';
import 'package:parkpaws/widgets/drawer.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Add Dog"),
        ),
        body: const AddDog());
  }
}

class AddDog extends StatefulWidget {
  const AddDog({Key? key}) : super(key: key);

  @override
  AddDogState createState() {
    return AddDogState();
  }
}

class AddDogState extends State<AddDog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  late final String url;
  File? _image;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Park Paws',
        home: Scaffold(
            body: Form(
                key: _formKey,
                child: Row(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                          ),
                          const Text('Add Doggy',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Borsok',
                                  color: AppColors.MAINTEXTBLACK)),
                          Image.asset(
                            'assets/images/dogheader2.png',
                            height: 120,
                            width: 120,
                          ),
                        ],
                      ),
                      CupertinoFormSection(
                        header: const Text('Dog Information'),
                        children: [
                          const SizedBox(
          height: 32,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: CircleAvatar(
              radius: 55,
              backgroundColor: const Color(0xffFDCF09),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          ),
        ),
                          // SizedBox(
                          //   width: 250,
                          //   child: CupertinoFormRow(
                          //     prefix: const Text('Dog Photo'),
                          //     child: ElevatedButton(
                          //       child: const Text("Upload Image",
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.w300,
                          //               fontSize: 15)),
                          //       onPressed: () {
                          //         // uploadImage();
                          //       },
                          //     ),
                          //   ),
                          // ),
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
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter a name.';
                                  }
                                  return null;
                                },
                                placeholder: 'Enter your dog\'s name',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: CupertinoFormRow(
                              prefix: const Text('Age'),
                              child: CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                controller: _ageController,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter a year.';
                                  }
                                  return null;
                                },
                                placeholder: 'Dog\'s year of birth',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
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
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter a color.';
                                  }
                                  return null;
                                },
                                placeholder: 'Enter your dog\'s color',
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            print("valid");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OwnerInfo([
                                  _nameController.text,
                                  _ageController.text,
                                  _colorController.text,
                                ]),
                              ),
                            );
                          }
                        },
                        child: const Text('Next'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          Navigator.pushNamed(context, Routes.home);
                        },
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ]))));
  }

  uploadImage(choice) async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile image;
    print(choice);
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      //Select Image
      image = (await _imagePicker.pickImage(source: choice))!;
      
      var file = File(image.path);
      

      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
        .child('dogs/imageName')
        .putFile(file).whenComplete(() => null);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        print(file);
        setState(() {
          // url = downloadUrl;
          _image = image as File?;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    uploadImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  uploadImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    );
}
// _imgFromCamera() async {
//   XFile? image = await ImagePicker.pickImage(
//     source: ImageSource.camera, imageQuality: 50
//   );

//   setState(() {
//     _image = image!;
//   });
// }

// _imgFromGallery() async {
//   XFile? image = await ImagePicker.pickImage(
//       source: ImageSource.gallery, imageQuality: 50
//   );

//   setState(() {
//     _image = image!;
//   });
// }
}

class OwnerInfo extends StatefulWidget {
  final List<String> previousFields;

  const OwnerInfo(
    this.previousFields, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OwnerInfoState();
  }
}

//second page
class _OwnerInfoState extends State<OwnerInfo> {
  final _formKey = GlobalKey<FormState>();
  List<String> allData = [];
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerSiteController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.MAINBGWHITE,
        body: Form(
            key: _formKey,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                            ),
                            const Text('Add Owner Info',
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
                          header: const Text('Owner Information'),
                          children: [
                            SizedBox(
                              width: 350,
                              child: CupertinoFormRow(
                                prefix: const Text('Owner Name'),
                                child: CupertinoTextFormFieldRow(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  controller: _ownerNameController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length <= 1) {
                                      return 'Please enter owner name.';
                                    }
                                    return null;
                                  },
                                  placeholder: 'Enter your name',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: CupertinoFormRow(
                                prefix: const Text('Site Number'),
                                child: CupertinoTextFormFieldRow(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  controller: _ownerSiteController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length <= 1) {
                                      return 'Please enter a site number.';
                                    }
                                    return null;
                                  },
                                  placeholder: 'Enter your site number',
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Checking your dog for fleas...')),
                              );
                              submitData();
                            }
                          },
                          child: const Text('Submit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            Navigator.pushNamed(context, Routes.add);
                          },
                          child: const Text('Back',
                              style: TextStyle(color: Colors.red)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            Navigator.pushNamed(context, Routes.home);
                          },
                          child: const Text('Home',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ])
                ])));
  }

  void submitData() {
    allData.addAll(widget.previousFields);
    allData.addAll([_ownerNameController.text, _ownerSiteController.text]);
    print(allData);
    // Submit your data
  }
}

// TextFormField(
                //   decoration: const InputDecoration(
                //     border: UnderlineInputBorder(),
                //     labelText: "Enter dog owner's name",
                //   ),
                //   // The validator receives the text that the user has entered.
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter dogs's owner name";
                //     }
                //     return null;
                //   },
                // ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     border: UnderlineInputBorder(),
                //     labelText: "Enter dog's age (in years)",
                //   ),
                //   // The validator receives the text that the user has entered.
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter dogs's age";
                //     }
                //     return null;
                //   },
                // ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     border: UnderlineInputBorder(),
                //     labelText: "Enter dog's color fur (dominant color)",
                //   ),
                //   // The validator receives the text that the user has entered.
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter dogs's fur color";
                //     }
                //     return null;
                //   },
                // ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     border: UnderlineInputBorder(),
                //     labelText: "Enter dog owner's site number",
                //   ),
                //   // The validator receives the text that the user has entered.
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter dog owner's site number";
                //     }
                //     return null;
                //   },
                // ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     border: UnderlineInputBorder(),
                //     labelText: "Upload a photo of your dog",
                //   ),
                //   // The validator receives the text that the user has entered.
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please upload a photo of your dog";
                //     }
                //     return null;
                //   },
                // ),