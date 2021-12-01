import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/utils/af_convert.dart';

class LocalMessage {
  String chatId;
  Message message;
  ReceiptStatus receipt;
  String _id = '';
  String get id => _id;

  LocalMessage({
    required this.chatId,
    required this.message,
    required this.receipt,
  });

  factory LocalMessage.dariMap(Map<String, dynamic> map) {
    final message = Message(
      from: AFconvert.keString(map['sender']),
      to: AFconvert.keString(map['receiver']),
      contents: AFconvert.keString(map['contents']),
      timestamp: AFconvert.keTanggal(map['received_at']),
      title: AFconvert.keString(map['title']),
      body: AFconvert.keString(map['body']),
    );

    final localMessage = LocalMessage(
      chatId: AFconvert.keString(map['chat_id']),
      message: message,
      receipt: ReceiptStatusParser.fromString(
        AFconvert.keString(map['receipt']),
      ),
    );
    localMessage._id = AFconvert.keString(map['id']);
    return localMessage;
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'chat_id': chatId,
      'id': message.id,
      'sender': message.from,
      'receiver': message.to,
      'contents': message.contents,
      'receipt': receipt.value(),
      'received_at': AFconvert.keString(message.timestamp),
    };
    return map;
  }
}
