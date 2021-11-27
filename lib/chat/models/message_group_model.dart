import 'package:simpel/utils/af_convert.dart';

class MessageGroup {
  String name;
  String photoUrl;
  String createdBy;
  List<String> members;
  String _id = '';
  String get id => _id;

  MessageGroup({
    this.name = '',
    this.photoUrl = '',
    this.createdBy = '',
    this.members = const [],
  });

  factory MessageGroup.dariMap(Map<String, dynamic> map) {
    final messageGroup = MessageGroup(
      name: AFconvert.keString(map['name']),
      photoUrl: AFconvert.keString(map['photo_url']),
      createdBy: AFconvert.keString(map['created_by']),
      members: AFconvert.keList(map['members']),
    );
    messageGroup._id = AFconvert.keString(map['id']);
    return messageGroup;
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'name': name,
      'photo_url': photoUrl,
      'created_by': createdBy,
      'members': AFconvert.keString(members),
    };
    return map;
  }
}
