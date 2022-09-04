class DogModel {
  late String name;
  late String dob;
  late String site;
  late String parent;
  late String color;
  late String photo;
  late String id;

  DogModel({
    required this.color,
    required this.name,
    required this.dob,
    required this.site,
    required this.parent,
    required this.photo,
    required this.id,
  });

  DogModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        dob = json['dob'] as String,
        site = json['site'] as String,
        parent = json['parent'] as String,
        color = json['color'] as String,
        photo = json['photo'] as String,
        id = json['id'] as String;
}
