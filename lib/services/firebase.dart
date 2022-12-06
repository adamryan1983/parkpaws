import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:parkpaws/models/dog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parkpaws/subpages/home.dart';


 final storageRef = FirebaseStorage.instance.ref();

// Child references can also take paths
// spaceRef now points to "images/space.jpg
// imagesRef still points to "images"
final spaceRef = storageRef.child("dogs/");
final gsReference =
    FirebaseStorage.instance.refFromURL("gs://parkpaws-9a9b0.appspot.com/dogs/");

class FirestoreDB extends GetxController {
  // Initialise Firebase Cloud Firestore
  Stream<Set<DogModel>> getAllDogs() {
    return FirebaseFirestore.instance
        .collection('dogs')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DogModel(
          color: (doc.data()['color'] as String),
          id: (doc.id),
          parent: (doc.data()['parent'] as String),
          dob: (doc.data()['dob'] as String),
          name: (doc.data()['name'] as String),
          site: (doc.data()['site'] as String),
          photo: (gsReference.toString()+doc.data()['photo']),
        );
      }).toSet();
    });
  }
  
    // Add a Dog method
  Future<bool> addNewDog(List<String> dogSpecs) async {


    
    try {
      await FirebaseFirestore.instance.collection('dogs').add({
        'name': dogSpecs[0],
        'color': dogSpecs[2],
        'parent': dogSpecs[3],
        'dob': dogSpecs[1],
        'site': dogSpecs[4],
        'photo': dogSpecs[0],
      }).then((value) => Get.off(Home())?.catchError(
            (onError) => Get.snackbar(
                "Error while adding dog ", onError.message,
                snackPosition: SnackPosition.BOTTOM),
          ),);
      return true;
    } catch (e) {
      return false;
    }
  }
}

