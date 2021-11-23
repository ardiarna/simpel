import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class IMessageService {
  Future<Message> send(Message message);
  Stream<Message> messages({required User activeUser});
  dispose();
}
