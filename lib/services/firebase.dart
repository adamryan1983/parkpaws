import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkpaws/models/dog.dart';

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
          photo: (doc.data()['photo'] as String),
        );
      }).toSet();
    });
  }
}
