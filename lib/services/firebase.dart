import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkpaws/models/dog.dart';
import 'package:firebase_storage/firebase_storage.dart';


 final storageRef = FirebaseStorage.instance.ref();

// Child references can also take paths
// spaceRef now points to "images/space.jpg
// imagesRef still points to "images"
final spaceRef = storageRef.child("dogs/");
final gsReference =
    FirebaseStorage.instance.refFromURL("gs://parkpaws-9a9b0.appspot.com/dogs/");

class FirestoreDB {
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
  Future<bool> addNewDog(DogModel dog) async {
    final fileRef = storageRef.child(dog.photo);
    try {
      await FirebaseFirestore.instance.collection('dogs').add({
        'name': dog.name,
        'color': dog.color,
        'parent': dog.parent,
        'dob': dog.dob,
        'site': dog.site,
        'photo': fileRef,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

