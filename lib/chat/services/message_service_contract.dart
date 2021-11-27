import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class IMessageService {
  Future<Message> send(List<Message> messages);
  Stream<Message> messages({required User activeUser});
  dispose();
}
