import 'package:realm/realm.dart';

part 'dog.g.dart';

@RealmModel()
class _Dog {
  late String name;
  late String dob;
  late String site;
  late String parent;
  late String color;
  late String photo;
}

//   DogModel({
//     required this.color,
//     required this.name,
//     required this.dob,
//     required this.site,
//     required this.parent,
//     required this.photo,
//   });

//   DogModel.fromJson(Map<String, dynamic> json)
//       : name = json['name'] as String,
//         dob = json['dob'] as String,
//         site = json['site'] as String,
//         parent = json['parent'] as String,
//         color = json['color'] as String,
//         photo = json['photo'] as String;
// }
