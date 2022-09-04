import '../models/dog.dart';
import 'package:get/get.dart';
import '../services/firebase.dart';

class DogListingController extends GetxController {
  // Add a list of Product objects.
  final allDogs = <DogModel>{}.obs;

  @override
  void onInit() {
    allDogs.bindStream(FirestoreDB().getAllDogs());
    super.onInit();
  }
}
