import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/utils/af_convert.dart';

class Chat {
  String id;
  int unread = 0;
  List<LocalMessage>? messages;
  LocalMessage? mostRecent;
  User? from;

  Chat(
    this.id, {
    this.messages,
    this.mostRecent,
    this.from,
  });

  factory Chat.dariMap(Map<String, dynamic> map) {
    return Chat(
      AFconvert.keString(map['id']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'id': id,
    };
    return map;
  }
}
