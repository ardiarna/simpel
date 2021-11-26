import 'package:simpel/utils/af_convert.dart';

class Message {
  final String from;
  final String to;
  final DateTime? timestamp;
  final String contents;
  String groupId;
  String _id = '';
  String get id => _id;

  Message({
    required this.from,
    required this.to,
    required this.timestamp,
    required this.contents,
    this.groupId = '',
  });

  factory Message.dariMap(Map<String, dynamic> map) {
    final message = Message(
      from: AFconvert.keString(map['sender']),
      to: AFconvert.keString(map['receiver']),
      timestamp: AFconvert.keTanggal(map['created_at']),
      contents: AFconvert.keString(map['contents']),
      groupId: AFconvert.keString(map['group_id']),
    );
    message._id = AFconvert.keString(map['id']);
    return message;
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'sender': from,
      'receiver': to,
      'created_at': AFconvert.keString(timestamp),
      'contents': AFconvert.keString(contents),
      'group_id': groupId,
    };
    return map;
  }
}
