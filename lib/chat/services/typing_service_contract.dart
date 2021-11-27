import 'package:simpel/chat/models/typing_event_model.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class ITypingNotification {
  Future<bool> send({required List<TypingEvent> events});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
