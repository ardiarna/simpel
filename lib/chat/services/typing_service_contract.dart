import 'package:simpel/chat/models/typing_event_model.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class ITypingNotification {
  Future<bool> send({required TypingEvent event});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
