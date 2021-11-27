import 'package:simpel/chat/models/user_model.dart';

abstract class IUserService {
  Future<User> create(User user);
  Future<User> connect(User user);
  Future<List<User>> online();
  Future<void> disconnect(String nik, DateTime lastseen);
  Future<List<User>> fetch(List<String> niks);
}
