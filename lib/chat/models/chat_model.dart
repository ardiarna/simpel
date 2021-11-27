import 'dart:convert';

import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/utils/af_convert.dart';

enum ChatType { individual, group }

extension ChatTypeParser on ChatType {
  String value() {
    return this.toString().split('.').last;
  }

  static ChatType fromString(String status) {
    return ChatType.values.firstWhere((element) => element.value() == status);
  }
}

class Chat {
  String id;
  ChatType type;
  int unread = 0;
  List<LocalMessage> messages;
  LocalMessage? mostRecent;
  List<User> members;
  List<Map> membersId;
  String name;
  String photoUrl;

  Chat(
    this.id,
    this.type, {
    this.messages = const [],
    this.mostRecent,
    this.members = const [],
    this.membersId = const [],
    this.name = '',
    this.photoUrl = '',
  });

  factory Chat.dariMap(Map<String, dynamic> map) {
    return Chat(
      AFconvert.keString(map['id']),
      ChatTypeParser.fromString(map['type']),
      membersId:
          List<Map>.from(map['members'].split(",").map((e) => jsonDecode(e))),
      name: AFconvert.keString(map['name']),
      photoUrl: AFconvert.keString(map['photo_url']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'photo_url': photoUrl,
      'type': type.value(),
      'members': membersId.map((e) => jsonEncode(e)).join(","),
    };
    return map;
  }
}
