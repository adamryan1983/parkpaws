import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkpaws/constants/colors.dart';
import 'package:parkpaws/routes/routes.dart';
import 'package:parkpaws/services/firebase.dart';
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
  File? _file;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                        height: 35,
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
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                              if (value!.isEmpty || value.length < 2) {
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
                              if (value!.isEmpty || value.length < 2) {
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
                              if (value!.isEmpty || value.length < 2) {
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
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OwnerInfo([
                                  _nameController.text.toLowerCase(),
                                  _ageController.text,
                                  _colorController.text.toLowerCase()
                                ], _file),
                              ),
                            );
                          }
                        },
                        child: const Text('Next'),
                      ),
                      const SizedBox(
                        width: 20,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  chooseImage(choice) async {
    final imagePicker = ImagePicker();
    XFile? image;

    //Check Permissions
    await Permission.photos.request();

    // var permissionStatus = await Permission.photos.status;
    // permissionStatus.isGranted;

    // if (permissionStatus.isGranted) {
      //Select Image
      image = (await imagePicker.pickImage(source: choice))!;
      // var file = File(image.path);
      File file = File(image.path);
      // image = XFile(image.path );

      setState(
        () {
          // url = downloadUrl;
          _image = file;
          _file = file;
        },
      );
    
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
                    chooseImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  chooseImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
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
  final File? file;

  const OwnerInfo(this.previousFields, this.file, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _OwnerInfoState();
  }
}

//second page
class _OwnerInfoState extends State<OwnerInfo> {
  final _formKey = GlobalKey<FormState>();
  List<String> allData = [];
  String? fileName;
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerSiteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.MAINBGWHITE,
      body: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Checking your dog for fleas...')),
                      );
                      submitData();
                    }
                  },
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.red, fontSize: 20)),
                ),
                SizedBox(
                  height: 100,
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          Navigator.pop(context);
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
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void submitData() {
    allData.addAll(widget.previousFields);
    allData.addAll(
        [_ownerNameController.text.toLowerCase(), _ownerSiteController.text]);
    print(allData);
    // Submit your data
    uploadFile(widget.file!.path, allData);
  }

  Future<void> uploadFile(fileName, data) async {
    final firebaseStorage = FirebaseStorage.instance;
    var dogName = data[0];
    // Upload your file
    var snapshot = await firebaseStorage
        .ref()
        .child('dogs/$dogName')
        .putFile(widget.file!)
        .whenComplete(() => null);
    // ignore: unused_local_variable
    var downloadUrl = await snapshot.ref.getDownloadURL();
    //add to database
    FirestoreDB().addNewDog(data);
  }
}
