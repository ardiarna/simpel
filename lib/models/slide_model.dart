import 'package:simpel/utils/af_convert.dart';

class SlidModel {
  int id;
  String title;
  String image;

  SlidModel({
    this.id = 0,
    this.title = '',
    this.image = '',
  });

  factory SlidModel.dariMap(Map<String, dynamic> map) {
    return SlidModel(
      id: AFconvert.keInt(map['slid_id']),
      title: AFconvert.keString(map['slid_title']),
      image: AFconvert.keString(map['slid_image']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'slid_id': id,
      'slid_title': title,
      'slid_image': image,
    };
    return map;
  }
}
