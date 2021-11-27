import 'package:simpel/utils/af_convert.dart';

enum Typing { start, stop }

extension TypingParser on Typing {
  String value() {
    return this.toString().split('.').last;
  }

  static Typing fromString(String event) {
    return Typing.values.firstWhere((element) => element.value() == event);
  }
}

class TypingEvent {
  final String from;
  final String to;
  final Typing event;
  String chatId;
  String _id = '';
  String get id => _id;

  TypingEvent({
    required this.from,
    required this.to,
    required this.event,
    required this.chatId,
  });

  factory TypingEvent.dariMap(Map<String, dynamic> map) {
    final receipt = TypingEvent(
      from: AFconvert.keString(map['sender']),
      to: AFconvert.keString(map['receiver']),
      event: TypingParser.fromString(map['event']),
      chatId: AFconvert.keString(map['chat_id']),
    );
    receipt._id = AFconvert.keString(map['id']);
    return receipt;
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'sender': from,
      'receiver': to,
      'event': event.value(),
      'chat_id': chatId,
    };
    return map;
  }
}
